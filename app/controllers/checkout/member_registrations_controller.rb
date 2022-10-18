module Checkout
  class MemberRegistrationsController < ApplicationController
    include CheckoutTravelPackage
    before_action :validate_booking_type
    before_action :validate_user_session

    def new_email_validation
      @customer_user = CustomerUser.new
    end

    def validate_email
      @customer_user = CustomerUser.find_by(email: customer_user_params[:email])

      if @customer_user.present?
        return redirect_to password_for_sign_in_checkout_member_registrations_path(
          params_for_next_request
        )
      end

      @customer_user = CustomerUser.new(customer_user_params)
      @customer_user.valid?

      if @customer_user.errors[:email].present?
        render :new_email_validation
      else
        MemberRegistrationMailer.send_verification_email_to_customer(params_for_next_request).deliver_now
        redirect_to email_verification_checkout_member_registrations_path(params_for_next_request)
      end
    end

    def password_for_sign_in
      @customer_user = CustomerUser.find_by(email: params[:email])

      if @customer_user.blank?
        redirect_to new_email_validation_checkout_member_registrations_path(
          params_for_next_request
        )
      end
    end

    def sign_in_customer_user
      @customer_user = CustomerUser.find_by(email: sign_in_params[:email])

      if @customer_user && @customer_user.valid_password?(sign_in_params[:password])
        sign_in(:customer_user, @customer_user)
        redirect_to_booking_process
      else
        @customer_user.errors[:password] << I18n.t('devise.failure.invalid_password')
        render :password_for_sign_in
      end
    end

    def new
      if params[:email].blank?
        return redirect_to new_email_validation_checkout_member_registrations_path(
          params_for_next_request
        )
      end

      @customer_user = CustomerUser.new(email: params[:email])
    end

    def create
      @customer_user = CustomerUser.new(customer_user_params)

      if @customer_user.save
        CustomerUserMailer.send_registration_confirmation(@customer_user).deliver_now
        sign_in(:customer_user, @customer_user)
        redirect_to_booking_process
      else
        render :new
      end
    end

    private

    def redirect_to_booking_process
      if params[:booking_type] == 'campsite_booking'
        redirect_to select_people_and_date_checkout_campsite_booking_path(
          params[:campsite_plan_id]
        )
      elsif params[:booking_type] == 'camp_car_booking'
        redirect_to select_place_and_date_checkout_camp_car_booking_path(params[:camp_car_id])
      elsif params[:booking_type] == 'tour_booking'
        # TODO: implement this one when work on tour booking
      else
        redirect_to root_path
      end
    end

    def params_for_next_request
      {
        email: @customer_user.email,
        booking_type: params[:booking_type],
        campsite_plan_id: params[:campsite_plan_id],
        camp_car_id: params[:camp_car_id]
      }
    end

    def sign_in_params
      params.require(:customer_user).permit(
        :email,
        :password
      )
    end

    def customer_user_params
      params.require(:customer_user).permit(
        :email,
        :birthday,
        :password,
        :last_name,
        :first_name,
        :country_id,
        :post_code,
        :address,
        :phone_number
      )
    end

    def validate_user_session
      if customer_user_signed_in?
        # TODO: redirect to next step
        redirect_back(fallback_location: root_path)
      end
    end
  end
end