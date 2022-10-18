module Checkout
  class CampCarBookingsController < ApplicationController
    include CheckoutTravelPackage

    before_action :check_remaining_camp_car_quantity, except: [
                                                                :calculate_price,
                                                                :check_remaining_quantity,
                                                                :thank_you
                                                              ]
    before_action :check_user_authentication

    def calculate_price
      travel_package = if params[:is_new_camp_car_booking].to_b
         TravelPackage.new
      else
        current_customer_user.current_travel_package_of_camp_car_booking
      end

      travel_package.assign_attributes(travel_package_params)
      booking_price_service = CampCarBookingPriceCalculationService.new(travel_package.camp_car_booking)
      travel_package.total_price = booking_price_service.calculate

      render json: travel_package, each_serializer: TravelPackageSerializer, include: '**'
    end

    def check_remaining_quantity
      camp_car_quantity_calculation_service = CampCarQuantityCalculationService.new(
        params, current_customer_user)

      result = camp_car_quantity_calculation_service.is_camp_car_out_of_stock?

      render json: {is_camp_car_out_of_stock: result}
    end

    # Step 1 of booking
    def select_place_and_date
      if request.post?
        current_customer_user.clean_up_old_incomplete_travel_package_of_camp_car_booking
        return redirect_to select_place_and_date_checkout_camp_car_booking_path(params[:id])
      end

      camp_car_booking_service = CampCarBookingService.new(
        current_customer_user,
        params,
        travel_package_of_camp_car_booking_draft: session[:travel_package_of_camp_car_booking_draft]
      )
      @travel_package = camp_car_booking_service.init_travel_package
    end

    # Submit step 1 of booking
    def create_booking
      session.delete(:travel_package_of_camp_car_booking_draft)

      handle_travel_package_params = travel_package_params.merge!(
        status: :incomplete,
        booking_type: :camp_car_booking,
        customer_user: current_customer_user,
        booked_by: current_customer_user
      )

      camp_car_booking_service = CampCarBookingService.new(
        current_customer_user, handle_travel_package_params
      )
      @travel_package = camp_car_booking_service.create_travel_package

      if @travel_package.persisted?
        redirect_to select_car_options_checkout_camp_car_bookings_path
      else
        flash[:alert] = @travel_package.errors.full_messages
        render :select_place_and_date
      end
    end

    # Step 2 of Booking
    def select_car_options
      @travel_package = current_customer_user.current_travel_package_of_camp_car_booking
    end

    # Submit step 2/3/4 of Booking
    def update_booking
      begin
        @travel_package = current_customer_user.current_travel_package_of_camp_car_booking
        @travel_package.assign_attributes(travel_package_params)

        booking_price_service = CampCarBookingPriceCalculationService.new(
          @travel_package.camp_car_booking
        )
        @travel_package.total_price = booking_price_service.calculate

        if @travel_package.save
          redirect_to_next_booking_step(current_customer_user, @travel_package)
        else
          flash[:alert] = @travel_package.errors.full_messages
          render params[:current_camp_car_booking_step]
        end

      rescue ActiveRecord::RecordNotFound => e
        flash[:alert] = I18n.t('checkout.camp_car_bookings.controller.camp_car_booking_invalid_on_update')
        redirect_to root_path
      end
    end

    # step 3
    def contact_information
      @travel_package = current_customer_user.current_travel_package_of_camp_car_booking
    end

    # step 4
    def confirm_information
      @travel_package = current_customer_user.current_travel_package_of_camp_car_booking
    end

    # step 6
    def thank_you
      @travel_package = current_customer_user.travel_packages.find(params[:travel_package_id])
    end

    private

    def redirect_to_next_booking_step(customer_user, travel_package)
      next_booking_path =
        if params[:current_camp_car_booking_step] == 'select_car_options'
          contact_information_checkout_camp_car_bookings_path
        elsif params[:current_camp_car_booking_step] == 'contact_information'
          confirm_information_checkout_camp_car_bookings_path
        elsif params[:current_camp_car_booking_step] == 'confirm_information'
          checkout_processor = CheckoutProcessor.new(customer_user, travel_package)
          checkout_processor.get_next_redirect_path
        end

      redirect_to next_booking_path
    end

    def travel_package_params

      permitted_params = params.require(:travel_package).permit(
        camp_car_booking_attributes: [
          :id, :camp_car_id, :start_date_of_renting, :end_date_of_renting,
          camp_car_options_included_in_booking_attributes: [
            :id,
            :camp_car_option_id,
            :quantity,
            :name
          ]
        ],
        booking_contact_information_attributes: booking_contact_information_attributes
      )

      permitted_params
    end

    def check_user_authentication
      if !customer_user_signed_in?
        redirect_to new_email_validation_checkout_member_registrations_path(
          booking_type: 'camp_car_booking',
          camp_car_id: params[:id]
        )
      end
    end

    def check_remaining_camp_car_quantity
      camp_car_quantity_calculation_service = CampCarQuantityCalculationService.new(
        params, current_customer_user, session)

      is_camp_car_out_of_stock = camp_car_quantity_calculation_service.is_camp_car_out_of_stock?

      if is_camp_car_out_of_stock
        redirect_to camp_car_path(camp_car_quantity_calculation_service.camp_car),
                      alert: t('camp_cars.error_messages.camp_car_is_out_of_stock')
      end
    end

  end
end
