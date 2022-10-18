class Admin::CampCategoryGroupsController < Admin::AdminController
  before_action :set_camp_category_group, only: %i[show edit update destroy]
  authorize_resource

  def index
    @q = CampCategoryGroup.ransack(params[:q])
    @camp_category_groups = @q.result.with_translations(I18n.locale).page(params[:page])
  end

  def new
    @camp_category_group = CampCategoryGroup.new
  end

  def create
    @camp_category_group = CampCategoryGroup.new(camp_category_group_params)

    if @camp_category_group.save
      redirect_to admin_camp_category_group_path(@camp_category_group), notice: I18n.t("controllers.created", model: CampCategoryGroup.model_name.human)
    else
      render :new, alert: @camp_category_group.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_category_group.update(camp_category_group_params)
      redirect_to admin_camp_category_group_path(@camp_category_group), notice: I18n.t("controllers.updated", model: CampCategoryGroup.model_name.human)
    else
      render :edit, alert: @camp_category_group.errors.full_messages
    end
  end

  def destroy
    @camp_category_group.destroy
    redirect_to admin_camp_category_groups_path(), notice: I18n.t("controllers.deleted", model: CampCategoryGroup.model_name.human)
  end

  private

  def camp_category_group_params
    params.require(:camp_category_group).permit([
        :is_facility_type,
        :is_the_facility_in_the_hall,
        :weight,
        :is_shown_on_the_front_end
      ] + CampCategoryGroup.globalize_attribute_names
    )
  end

  def set_camp_category_group
    @camp_category_group = CampCategoryGroup.find params[:id]
  end
end