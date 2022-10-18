module Checkout
  class CampsiteBookingsController < ApplicationController
    include CheckoutTravelPackage

    before_action :check_remaining_campsite_plan_quantity, except: [
                                                                      :calculate_price,
                                                                      :check_remaining_quantity,
                                                                      :thank_you,
                                                                      :edit # In case edit completed booking from my page
                                                                    ]
    before_action :check_max_number_of_people, only: [:select_people_and_date, :create_booking, :update_booking]
    before_action :check_user_authentication
    before_action :set_travel_package, only: [:calculate_price, :edit, :update_booking]

    def calculate_price
      travel_package = if params[:is_new_campsite_booking].to_b
         TravelPackage.new
      else
        @travel_package
      end

      travel_package.assign_attributes(travel_package_params)
      campsite_booking = travel_package.campsite_booking
      campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

      booking_price_service = CampsiteBookingPriceCalculationService.new(
        campsite_booking,
        with_entrance_fee: !campsite_plan_is_included_entrance_fee
      )
      travel_package.total_price = booking_price_service.calculate

      resp = TravelPackageSerializer.new(travel_package).serializable_hash(include: '**')
      resp[:error_messages] = booking_price_service.error_messages

      render json: resp
    end

    def check_remaining_quantity
      campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
        params, current_customer_user)

      result = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?

      render json: {is_campsite_plan_out_of_stock: result}
    end

    # Step 1 of booking
    def select_people_and_date
      if request.post?
        current_customer_user.clean_up_old_incomplete_travel_package_of_campsite_booking
        return redirect_to select_people_and_date_checkout_campsite_booking_path(params[:id])
      end
      campsite_booking_service = CampsiteBookingService.new(
        current_customer_user,
        params,
        travel_package_of_campsite_booking_draft: session[:travel_package_of_campsite_booking_draft]
      )
      @travel_package = campsite_booking_service.init_travel_package
    end

    # Submit step 1 of booking
    def create_booking
      session.delete(:travel_package_of_campsite_booking_draft)

      handle_travel_package_params = travel_package_params.merge!(
        status: :incomplete,
        booking_type: :campsite_booking,
        customer_user: current_customer_user,
        booked_by: current_customer_user
      )

      campsite_booking_service = CampsiteBookingService.new(
        current_customer_user, handle_travel_package_params
      )
      @travel_package = campsite_booking_service.create_travel_package

      if @travel_package.persisted?
        redirect_to select_plan_options_checkout_campsite_bookings_path
      else
        flash[:alert] = @travel_package.errors.full_messages.join(', ')
        render :select_people_and_date
      end
    end

    # Step 2 of Booking
    def select_plan_options
      @travel_package = current_customer_user.current_travel_package_of_campsite_booking
    end

    # Submit step 2/3/4 of Booking
    def update_booking
      begin
        @travel_package.assign_attributes(travel_package_params)
        campsite_booking = @travel_package.campsite_booking
        campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

        booking_price_service = CampsiteBookingPriceCalculationService.new(
          campsite_booking,
          with_entrance_fee: !campsite_plan_is_included_entrance_fee
        )
        @travel_package.total_price = booking_price_service.calculate

        # https://app.clickup.com/t/2cbycrw | Booking Form : Number of Male, Female fields
        if ['contact_information', 'confirm_information'].include?(params[:current_campsite_booking_step])
          @travel_package.booking_contact_information.is_validate_number_of_people = true
        end

        if @travel_package.save
          redirect_to_next_booking_step(current_customer_user, @travel_package)
        else
          handle_error_messages(@travel_package)

          render params[:current_campsite_booking_step]
        end

      rescue ActiveRecord::RecordNotFound => e
        flash[:alert] = I18n.t('checkout.campsite_bookings.controller.campsite_booking_invalid_on_update')
        redirect_to root_path
      end
    end

    # step 3
    def contact_information
      @travel_package = current_customer_user.current_travel_package_of_campsite_booking
    end

    # step 4
    def confirm_information
      @travel_package = current_customer_user.current_travel_package_of_campsite_booking
    end

    # step 6
    def thank_you
      @travel_package = current_customer_user.travel_packages.find(params[:travel_package_id])
    end

    # for edit and update booking from my page
    def edit
      if !@travel_package.is_editable?
        return redirect_back(fallback_location: root_path)
      end

      render :confirm_information
    end

    private

    def redirect_to_next_booking_step(customer_user, travel_package)
      next_booking_path =
        if !travel_package.status_incomplete? # In case edit completed booking from my page
          flash[:notice] = I18n.t('customer.campsite_bookings.updated')
          my_page_path(travel_package_id: travel_package.id)
        elsif params[:current_campsite_booking_step] == 'select_plan_options'
          contact_information_checkout_campsite_bookings_path
        elsif params[:current_campsite_booking_step] == 'contact_information'
          confirm_information_checkout_campsite_bookings_path
        elsif params[:current_campsite_booking_step] == 'confirm_information'
          checkout_processor = CheckoutProcessor.new(customer_user, travel_package)
          checkout_processor.get_next_redirect_path
        end


      redirect_to next_booking_path
    end

    def travel_package_params
      permitted_params = params.require(:travel_package).permit(
        campsite_booking_attributes: [
          :id, :campsite_plan_id, :check_in, :check_out, :number_of_adult,
          child_and_pet_included_in_bookings_attributes: [
            :id,
            :child_and_pet_setting_id,
            :entity_type,
            :quantity
          ] + ChildAndPetIncludedInBooking.globalize_attribute_names,
          campsite_options_included_in_booking_attributes: [
            :id,
            :campsite_plan_option_id,
            :quantity
          ] + CampsiteOptionIncludedInBooking.globalize_attribute_names,
          booking_messages_attributes: [
            :id,
            :subject,
            :customer_user_id,
            booking_message_details_attributes: [:id, :booking_message_id, :owner_type, :owner_id, :message]
          ]
        ],
        booking_contact_information_attributes: booking_contact_information_attributes
      )

      permitted_params
    end

    def check_user_authentication
      if !customer_user_signed_in?
        redirect_to new_email_validation_checkout_member_registrations_path(
          booking_type: 'campsite_booking',
          campsite_plan_id: params[:id]
        )
      end
    end

    def set_travel_package
      @travel_package = current_customer_user.travel_packages.find_by(id: params[:travel_package_id]) ||
                        current_customer_user.current_travel_package_of_campsite_booking
    end

    def check_remaining_campsite_plan_quantity
      campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
        params, current_customer_user, session)

      is_campsite_plan_out_of_stock = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?

      if is_campsite_plan_out_of_stock
        redirect_to campsite_plan_path(campsite_plan_quantity_calculation_service.campsite_plan),
                      alert: t('campsite_plans.error_messages.campsite_plan_is_out_of_stock')
      end
    end

    def check_max_number_of_people
      campsite_booking =
        # In the case submit step 1 of booking
        if action_name == 'create_booking'
          travel_package = TravelPackage.new(travel_package_params)
          travel_package.campsite_booking
        # In the case submit step 2/3/4 of booking
        elsif action_name == 'update_booking'
          travel_package = set_travel_package

          travel_package.assign_attributes(travel_package_params)
          travel_package.campsite_booking
        # In case step 1 of booking
        elsif session[:travel_package_of_campsite_booking_draft]&.dig('campsite_booking').present?
          campsite_booking_params = session[:travel_package_of_campsite_booking_draft].dig('campsite_booking')
          campsite_booking_params = campsite_booking_params.except('number_of_nights', 'number_of_children')
          campsite_booking_params[:child_and_pet_included_in_bookings_attributes] = campsite_booking_params.delete('child_and_pet_included_in_bookings')

          CampsiteBooking.new(campsite_booking_params)
        # In the case back step 1 of booking
        elsif current_customer_user.current_travel_package_of_campsite_booking.present?
          travel_package = current_customer_user.current_travel_package_of_campsite_booking
          travel_package.campsite_booking
        end

      if campsite_booking.is_more_than_the_number_of_people_allowed?
        redirect_back fallback_location: root_path,
          flash: {error_max_number_of_people: I18n.t('checkout.campsite_bookings.error_messages.error_max_number_of_people')}
      end
    end

    def handle_error_messages(travel_package)
      travel_package.valid?
      error_messages = []

      # put attributes errors messages need to show on UI
      [

      ].each do |attribute|
        if travel_package.errors.has_key? attribute
          error_messages << travel_package.errors.messages_for(attribute)
        end
      end

      flash[:alert] = error_messages.join(', ') if error_messages.present?
    end

  end
end
