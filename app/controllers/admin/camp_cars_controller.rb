class Admin::CampCarsController < Admin::AdminController
  before_action :set_camp_car, only: %i[show edit update destroy]
  authorize_resource

  def index
    @camp_cars = CampCar.page(params[:page]).order(created_at: :desc)
  end

  def new
    @camp_car = CampCar.new
  end

  def create
    @camp_car = CampCar.new(camp_car_params)

    if @camp_car.save
      redirect_to admin_camp_car_path(@camp_car), notice: I18n.t("controllers.created", model: CampCar.model_name.human)
    else
      render :new, alert: @camp_car.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_car.update(camp_car_params)
      redirect_to admin_camp_car_path(@camp_car), notice: I18n.t("controllers.updated", model: CampCar.model_name.human)
    else
      render :edit, alert: @camp_car.errors.full_messages
    end
  end

  def destroy
    @camp_car.destroy
    redirect_to admin_camp_cars_path(), notice: I18n.t("controllers.deleted", model: CampCar.model_name.human)
  end

  private

  def camp_car_params
    while_list = [
      :product_id,
      :car_type,
      :quantity,
      :category_id,
      :tag_list,
      :maximum_number_of_people,
      :is_public,
      :fee_per_hour,
      :fee_per_day,
      :supplier_company_id,
      :state_id,
      :prefecture_id,
      photos_attributes: [:id, :image, :_destroy],
      camp_car_quantities_attributes: [
        :id, :date, :quantity, :_destroy
      ],
      camp_car_option_ids: []
    ]

    params.require(:camp_car).permit(while_list + CampCar.globalize_attribute_names)
  end

  def set_camp_car
    @camp_car = CampCar.find params[:id]
  end
end