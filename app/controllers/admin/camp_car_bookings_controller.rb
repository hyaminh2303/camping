class Admin::CampCarBookingsController < Admin::AdminController
  before_action :set_camp_car_booking_and_travel_package, only: %i[ show edit calculate_price update add_note_form add_note ]
  before_action :assign_travel_package_attributes, only: %i[ calculate_price update ]
  before_action :can_not_edit_for_credit_card_payment_method, only: %i[ edit update ]

  authorize_resource

  def index
    @q = CampCarBooking.without_incomplete_booking.ransack(params[:q])
    @camp_car_bookings = @q.result.page(params[:page]).order(start_date_of_renting: :desc)
  end

  def show
  end

  def edit
    if !@travel_package.is_editable?
      redirect_to admin_camp_car_booking_path(@camp_car_booking)
    end
  end

  def calculate_price
    render json: @travel_package, each_serializer: TravelPackageSerializer, include: '**'
  end

  def update
    if @travel_package.save
      redirect_to admin_camp_car_booking_path(@camp_car_booking), notice: I18n.t("controllers.updated", model: CampCarBooking.model_name.human)
    else
      render :edit
    end
  end

  def add_note_form
    render layout: false
  end

  def add_note
    # https://app.clickup.com/t/1ydkwpw
    @camp_car_booking.update_column(:note, params.dig(:camp_car_booking, :note))
    redirect_back fallback_location: admin_camp_car_bookings_path, notice: I18n.t("controllers.created", model: t('admin.camp_car_bookings.index.note'))
  end

  private

  def set_camp_car_booking_and_travel_package
    camp_car_booking_id = params[:id] || params[:camp_car_booking_id]

    @camp_car_booking = CampCarBooking.find camp_car_booking_id
    @travel_package = @camp_car_booking.travel_package
  end

  def travel_package_params
    params.require(:travel_package).permit(
      camp_car_booking_attributes: [
        :id,
        :start_date_of_renting,
        :end_date_of_renting
      ],
      booking_contact_information_attributes: [
        :id,
        :address,
        :birthday,
        :email,
        :name,
        :phone_number
      ]
    )
  end

  def assign_travel_package_attributes
    @travel_package.assign_attributes(travel_package_params)

    booking_price_service = CampCarBookingPriceCalculationService.new(@travel_package.camp_car_booking)
    @travel_package.total_price = booking_price_service.calculate

    @travel_package
  end

  def can_not_edit_for_credit_card_payment_method
    if @camp_car_booking.travel_package.payment_method.credit_card?
      redirect_to admin_camp_car_bookings_path, alert: t('activerecord.errors.messages.can_not_edit_for_credit_card_payment_method')
    end
  end

end