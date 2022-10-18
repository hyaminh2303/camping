class Admin::CampCategoriesController < Admin::AdminController
  before_action :set_camp_category, only: %i[show edit update destroy]
  authorize_resource

  def index
    @q = CampCategory.ransack(params[:q])
    @camp_categories = @q.result.with_translations(I18n.locale).
                       with_camp_category_group_translations(I18n.locale).
                       page(params[:page])
  end

  def new
    @camp_category = CampCategory.new
  end

  def create
    @camp_category = CampCategory.new(camp_category_params)

    if @camp_category.save
      redirect_to admin_camp_category_path(@camp_category), notice: I18n.t("controllers.created", model: CampCategory.model_name.human)
    else
      render :new, alert: @camp_category.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_category.update(camp_category_params)
      redirect_to admin_camp_category_path(@camp_category), notice: I18n.t("controllers.updated", model: CampCategory.model_name.human)
    else
      render :edit, alert: @camp_category.errors.full_messages
    end
  end

  def destroy
    @camp_category.destroy
    redirect_to admin_camp_categories_path(), notice: I18n.t("controllers.deleted", model: CampCategory.model_name.human)
  end

  private

  def camp_category_params
    params.require(:camp_category).permit([
        :camp_category_group_id,
        :weight
      ] + CampCategory.globalize_attribute_names
    )
  end

  def set_camp_category
    @camp_category = CampCategory.find params[:id]
  end
end