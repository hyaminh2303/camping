# frozen_string_literal: true

class CustomerUsers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new_email_validation
    @customer_user = CustomerUser.new

    if customer_user_signed_in?
      redirect_back(fallback_location: root_path)
    end
  end

  def validate_email
    @customer_user = CustomerUser.new(validate_params)
    @customer_user.valid?

    if @customer_user.errors[:email].present?
      render :new_email_validation
    else
      CustomerUserMailer.send_verification_email_to_customer(@customer_user).deliver_now
      redirect_to email_validation_path(@customer_user)
    end
  end

  def email_validation; end

  # GET /resource/sign_up
  def new
    build_resource
    resource.email = params[:email]
    yield resource if block_given?
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save

    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        CustomerUserMailer.send_registration_confirmation(resource).deliver_now
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to root_path, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    set_travel_packages # set data for my_page/show

    if resource.update(account_update_params)
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      redirect_to my_page_path(is_updating_profile: true)
    else
      clean_up_passwords resource
      set_minimum_password_length

      render 'my_pages/show', locals: { is_updating_profile: true }
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    CustomerUserMailer.send_withdrawal_membership_confirmation_email_to_customer(resource).deliver_now

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed

    yield resource if block_given?

    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: account_attributes)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: account_attributes, except: without_password)
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def validate_params
    params.require(:customer_user).permit(:email)
  end

  def account_attributes
    [
      :email,
      :password,
      :password_confirmation,
      :last_name,
      :first_name,
      :country_id,
      :birthday,
      :post_code,
      :address,
      :phone_number
    ]
  end

  def without_password
    if params[:customer_user].try(:[], :password).blank?
      [:password, :password_confirmation]
    else
      []
    end
  end

  def set_travel_packages
    @travel_packages = current_customer_user.travel_packages.page(params[:page])
  end

end
