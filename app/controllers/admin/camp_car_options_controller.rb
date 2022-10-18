class Admin::CampCarOptionsController < Admin::AdminController
  before_action :set_camp_car_option, only: %i[show edit update destroy]
  authorize_resource

  def index
    @camp_car_options = CampCarOption.page(params[:page]).order(created_at: :desc)
  end

  def new
    @camp_car_option = CampCarOption.new
  end

  def create
    @camp_car_option = CampCarOption.new(camp_car_option_params)

    if @camp_car_option.save
      redirect_to admin_camp_car_option_path(@camp_car_option), notice: I18n.t("controllers.created", model: CampCarOption.model_name.human)
    else
      render :new, alert: @camp_car_option.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_car_option.update(camp_car_option_params)
      redirect_to admin_camp_car_option_path(@camp_car_option), notice: I18n.t("controllers.updated", model: CampCarOption.model_name.human)
    else
      render :edit, alert: @camp_car_option.errors.full_messages
    end
  end

  def destroy
    @camp_car_option.destroy
    redirect_to admin_camp_car_options_path(), notice: I18n.t("controllers.deleted", model: CampCarOption.model_name.human)
  end

  private

  def camp_car_option_params
    params.require(:camp_car_option).permit([
        :fee_per_day,
        :supplier_company_id
      ] + CampCarOption.globalize_attribute_names
    )
  end

  def set_camp_car_option
    @camp_car_option = CampCarOption.find params[:id]
  end
end