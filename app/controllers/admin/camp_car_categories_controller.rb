class Admin::CampCarCategoriesController < Admin::AdminController
  before_action :set_camp_car_category, only: %i[show edit update destroy]
  authorize_resource

  def index
    @camp_car_categories = CampCarCategory.page(params[:page]).order(created_at: :desc)
  end

  def new
    @camp_car_category = CampCarCategory.new
  end

  def create
    @camp_car_category = CampCarCategory.new(camp_car_category_params)

    if @camp_car_category.save
      redirect_to admin_camp_car_category_path(@camp_car_category), notice: I18n.t("controllers.created", model: CampCarCategory.model_name.human)
    else
      render :new, alert: @camp_car_category.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_car_category.update(camp_car_category_params)
      redirect_to admin_camp_car_category_path(@camp_car_category), notice: I18n.t("controllers.updated", model: CampCarCategory.model_name.human)
    else
      render :edit, alert: @camp_car_category.errors.full_messages
    end
  end

  def destroy
    @camp_car_category.destroy
    redirect_to admin_camp_car_categories_path(), notice: I18n.t("controllers.deleted", model: CampCarCategory.model_name.human)
  end

  private

  def camp_car_category_params
    params.require(:camp_car_category).permit([
        :seats,
        :pick_up_drop_off_place_id
      ] + CampCarCategory.globalize_attribute_names
    )
  end

  def set_camp_car_category
    @camp_car_category = CampCarCategory.find params[:id]
  end
end