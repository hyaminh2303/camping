class Admin::CampsiteBookingsController < Admin::AdminController
  include CheckoutTravelPackage

  before_action :set_campsite_booking_and_travel_package, only: %i[ show edit calculate_price update add_note_form add_note ]
  before_action :assign_travel_package_attributes_and_update_the_total_price, only: %i[ calculate_price update ]
  before_action :can_not_edit_for_credit_card_payment_method, only: %i[ edit update ]
  before_action :set_required_params, only: %i[ new create edit update check_remaining_quantity]
  before_action :check_remaining_campsite_plan_quantity, only: %i[ create update ]
  authorize_resource

  def index
    @q = CampsiteBooking.without_incomplete_booking.ransack(params[:q])
    @campsite_bookings = @q.result.page(params[:page]).order(check_in: :desc)
  end

  def new
    init_travel_package
  end

  def create
    handle_travel_package_params = travel_package_params.merge!(
      status: :booked,
      booking_type: :campsite_booking,
      payment_method: :cash,
      is_booking_outside: true,
      booked_by: current_admin_user
    )

    @travel_package = TravelPackage.new(handle_travel_package_params)
    set_price_for_campsite_options_included_in_booking
    campsite_booking = @travel_package.campsite_booking
    campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

    booking_price_service = CampsiteBookingPriceCalculationService.new(
      campsite_booking,
      with_entrance_fee: !campsite_plan_is_included_entrance_fee
    )
    @travel_package.total_price = booking_price_service.calculate

    # https://app.clickup.com/t/2cbycrw | Booking Form : Number of Male, Female fields
    @travel_package.booking_contact_information.is_validate_number_of_people = true

    if @travel_package.save
      CampsiteBookingMailer.send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_customer(@travel_package).deliver_now
      CampsiteBookingMailer.send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_admin(@travel_package).deliver_now

      redirect_to admin_campsite_booking_path(@travel_package.campsite_booking), notice: I18n.t('admin.campsite_bookings.messages.created')
    else
      custom_error_messages_for(@travel_package)

      render :new, alert: @travel_package.errors.full_messages
    end
  end

  def show
  end

  def edit
    if !@travel_package.is_editable?
      redirect_to admin_campsite_booking_path(@campsite_booking)
    end
  end

  def calculate_price
    render json: @travel_package, each_serializer: TravelPackageSerializer, include: '**'
  end

  def update
    # https://app.clickup.com/t/2cbycrw | Booking Form : Number of Male, Female fields
    @travel_package.booking_contact_information.is_validate_number_of_people = true

    if @travel_package.save
      redirect_to admin_campsite_booking_path(@campsite_booking), notice: I18n.t("controllers.updated", model: CampsiteBooking.model_name.human)
    else
      custom_error_messages_for(@travel_package)

      render :edit
    end
  end

  def add_note_form
    render layout: false
  end

  def add_note
    # https://app.clickup.com/t/1ydkwpw
    @campsite_booking.update_column(:note, params.dig(:campsite_booking, :note))
    redirect_back fallback_location: admin_campsite_bookings_path, notice: I18n.t("controllers.created", model: t('admin.campsite_bookings.index.note'))
  end

  def check_remaining_quantity
    campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
      params, @customer_user )

    result = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?
    render json: {is_campsite_plan_out_of_stock: result}
  end

  private

  def set_price_for_campsite_options_included_in_booking
    @travel_package.campsite_booking.campsite_options_included_in_booking.each do |campsite_option_included_in_booking|
      price = campsite_option_included_in_booking.campsite_plan_option.price

      campsite_option_included_in_booking.price = price
    end
  end

  def set_campsite_booking_and_travel_package
    campsite_booking_id = params[:campsite_booking_id] || params[:id] # for calculating price in the edit form and showing booking
    @campsite_booking = CampsiteBooking.find_by(id: campsite_booking_id)

    @travel_package = !params[:is_new_campsite_booking].to_b && @campsite_booking.present? ?
                      @campsite_booking.travel_package : TravelPackage.new
  end

  def travel_package_params
    permitted_params = params.require(:travel_package).permit(
      :customer_user_id,
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
      ],
      booking_contact_information_attributes: booking_contact_information_attributes
    )

    permitted_params
  end

  def assign_travel_package_attributes_and_update_the_total_price
    @travel_package.assign_attributes(travel_package_params)
    set_price_for_campsite_options_included_in_booking if @travel_package.new_record?
    campsite_booking = @travel_package.campsite_booking
    campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

    booking_price_service = CampsiteBookingPriceCalculationService.new(
      campsite_booking,
      with_entrance_fee: !campsite_plan_is_included_entrance_fee
    )
    @travel_package.total_price = booking_price_service.calculate

    @travel_package
  end

  def can_not_edit_for_credit_card_payment_method
    if @campsite_booking.travel_package.payment_method.credit_card?
      redirect_to admin_campsite_bookings_path, alert: t('activerecord.errors.messages.can_not_edit_for_credit_card_payment_method')
    end
  end

  def init_travel_package
    return if @campsite_plan.blank?

    campsite_booking_service = AdminCampsiteBookingService.new(params, @customer_user)
    @travel_package = campsite_booking_service.init_travel_package
  end

  def set_required_params
    if action_name == 'edit' || action_name == 'update'
      return if @travel_package.blank?

      @customer_user = @travel_package.customer_user
      @campsite_plan = @travel_package.campsite_booking.campsite_plan
      @campsite = @campsite_plan.campsite
    else

      customer_user_id = params[:customer_user_id] || params[:travel_package].try(:[], :customer_user_id)
      @customer_user = CustomerUser.find_by(id: customer_user_id)

      campsite_plan_id = params[:campsite_plan_id] ||
                        params[:travel_package].try(:[], :campsite_booking_attributes).try(:[], :campsite_plan_id)

      campsite_id = params[:campsite_id] || CampsitePlan.find_by(id: campsite_plan_id)&.campsite_id

      @campsite = Campsite.find_by(id: campsite_id)
      @campsite_plan = @campsite&.campsite_plans&.find_by(id: campsite_plan_id)

    end
  end

  def check_remaining_campsite_plan_quantity
    set_required_params

    campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
      params, @customer_user)

    is_campsite_plan_out_of_stock = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?

    if is_campsite_plan_out_of_stock
      redirect_back fallback_location: admin_campsite_bookings_path,
                    alert: t('campsite_plans.error_messages.campsite_plan_is_out_of_stock')
    end
  end

  def custom_error_messages_for(travel_package)
    errors = []
    travel_package.valid?

    if travel_package.errors.has_key?(:"campsite_booking.max_number_of_people")
      errors << travel_package.errors.messages_for(:"campsite_booking.max_number_of_people")
    end

    flash[:alert] = errors.join(', ') if errors.present?
  end

end