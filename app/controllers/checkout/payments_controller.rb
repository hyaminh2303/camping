module Checkout
  class PaymentsController < ApplicationController
    include CheckoutTravelPackage
    before_action :authenticate_customer_user!
    before_action :set_travel_package
    before_action :validate_booking_step
    before_action :build_credit_card, only: [:new, :add_card]
    before_action :check_remaining_quantity

    def new; end

    def add_card
      if @travel_package.credit_card_addition_expired_at < Time.current

        if @travel_package.status_booked?
          @travel_package.update(
            status: :canceled,
            canceled_at: Time.current,
            canceled_by: current_admin_user
          )
        end

        render "credit_card_addition_expired"
      end
    end

    def create
      @credit_card = current_customer_user.credit_cards.build(credit_card_params)

      if @credit_card.valid?
        payment_processor = PaymentProcessor.new(
          current_customer_user,
          @credit_card,
          @travel_package
        )


        payment_processor.process

        if payment_processor.run_success
          @credit_card.save
          redirect_to_booking_process_successfully
        else
          flash[:alert] = if locale == :ja
              I18n.t('payments.check_info_credit_card')
            else
              payment_processor.message
            end
          render_form_occurred_error
        end
      else
        render_form_occurred_error
      end
    end

    def credit_card_addition_expired; end

    private

    def set_travel_package
      @travel_package ||=
        if params[:booking_type].present? && params[:travel_package_id].blank?
          validate_booking_type

          if params[:booking_type] == 'campsite_booking'
            current_customer_user.current_travel_package_of_campsite_booking
          elsif params[:booking_type] == 'camp_car_booking'
            current_customer_user.current_travel_package_of_camp_car_booking
          elsif params[:booking_type] == 'tour_booking'
            # TODO: implement this one when work on tour booking
          else
            raise 'Missing booking type'
          end

        elsif params[:travel_package_id].present? # for the case booking before 60 days, then adding the credit card
          begin
            current_customer_user.travel_packages.with_status(:booked, :canceled).
            with_payment_method(:credit_card).without_gmo_transaction.find(params[:travel_package_id])
          rescue ActiveRecord::RecordNotFound => e
            flash[:alert] = I18n.t('admin.payments.add_card.error_messages.booking_not_found')
            redirect_to root_path
          end
        end

    end

    def build_credit_card
      @credit_cards = current_customer_user.credit_cards
      @credit_card = current_customer_user.credit_cards.build
    end

    def redirect_to_booking_process_successfully
      return redirect_to root_path if params[:is_adding_the_card_for_60_days_before_starting].to_b # TODO: redirect_to travel_package_path(@travel_package)

      redirect_params = { travel_package_id: @travel_package.id, locale: I18n.locale }

      if @travel_package.booking_type_campsite_booking?
        redirect_to thank_you_checkout_campsite_bookings_path(redirect_params)
      elsif @travel_package.booking_type_camp_car_booking?
        redirect_to thank_you_checkout_camp_car_bookings_path(redirect_params)
      elsif @travel_package.booking_type_tour_booking?
        # TODO: implement this one when work on tour booking
      else
        redirect_to root_path
      end
    end

    def credit_card_params
      params.require(:credit_card).permit(
        :card_holder_name,
        :number,
        :exp_month,
        :exp_year,
        :cvc
      )
    end

    def validate_booking_step
      travel_package = set_travel_package

      if travel_package.booking_contact_information.blank?
        redirect_path =
          if travel_package.booking_type_campsite_booking?
            confirm_information_checkout_campsite_bookings_path
          elsif travel_package.booking_type_campsite_booking?
            confirm_information_checkout_camp_car_bookings_path
          elsif travel_package.booking_type_campsite_booking?
            # TODO: implement this one when work on tour booking
          else
            raise 'Booking type not found'
          end

        redirect_to redirect_path
      end
    end

    def render_form_occurred_error
      if params[:is_adding_the_card_for_60_days_before_starting].to_b
        render :add_card
      else
        render :new
      end
    end

    def check_remaining_quantity
      set_travel_package

      return if @travel_package.status_booked? # In the case of a reminder to add a credit card (after booking 60 days)

      if @travel_package.booking_type_campsite_booking?
        check_remaining_campsite_plan_quantity
      elsif @travel_package.booking_type_camp_car_booking?
        check_remaining_camp_car_quantity
      elsif @travel_package.booking_type_tour_booking?
        # TODO Tour
      end
    end

    def check_remaining_campsite_plan_quantity
      travel_package_params = {
        campsite_plan_id: @travel_package.campsite_booking.campsite_plan_id,
        check_in: @travel_package.check_in,
        check_out: @travel_package.check_out
      }

      campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
        travel_package_params, current_customer_user)

      is_campsite_plan_out_of_stock = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?

      if is_campsite_plan_out_of_stock
        redirect_to campsite_plan_path(campsite_plan_quantity_calculation_service.campsite_plan),
                      alert: t('campsite_plans.error_messages.campsite_plan_is_out_of_stock')
      end
    end

    def check_remaining_camp_car_quantity
      travel_package_params = {
        camp_car_id: @travel_package.camp_car_booking.camp_car_id,
        check_in: @travel_package.check_in,
        check_out: @travel_package.check_out
      }

      camp_car_quantity_calculation_service = CampCarQuantityCalculationService.new(
        travel_package_params, current_customer_user)

      is_camp_car_out_of_stock = camp_car_quantity_calculation_service.is_camp_car_out_of_stock?

      if is_camp_car_out_of_stock
        redirect_to camp_car_path(camp_car_quantity_calculation_service.camp_car),
                      alert: t('campsite_plans.error_messages.campsite_plan_is_out_of_stock')
      end
    end

  end
end