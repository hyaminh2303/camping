class Admin::CampsitePlanOptionsController < Admin::AdminController
  before_action :set_campsite_plan_option, only: %i[show edit update destroy]
  authorize_resource

  def index
    @q = campsite_plan_options_by_current_tenant.ransack(params[:q])
    @campsite_plan_options = @q.result.with_translations(I18n.locale).page(params[:page]).order(created_at: :desc)
  end

  def new
    @campsite_plan_option = CampsitePlanOption.new
  end

  def create
    @campsite_plan_option = CampsitePlanOption.new(campsite_plan_option_params)

    if @campsite_plan_option.save
      redirect_to admin_campsite_plan_option_path(@campsite_plan_option), notice: I18n.t('controllers.created', model: CampsitePlanOption.model_name.human)
    else
      render :new, alert: @campsite_plan_option.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @campsite_plan_option.update(campsite_plan_option_params)
      redirect_to admin_campsite_plan_option_path(@campsite_plan_option), notice: I18n.t('controllers.updated', model: CampsitePlanOption.model_name.human)
    else
      render :edit, alert: @campsite_plan_option.errors.full_messages
    end
  end

  def destroy
    @campsite_plan_option.destroy
    redirect_to admin_campsite_plan_options_path(), notice: I18n.t('controllers.deleted', model: CampsitePlanOption.model_name.human)
  end

  private

  def campsite_plan_option_params
    params.require(:campsite_plan_option).permit([
        :campsite_id,
        :price,
        :quantity
      ] + CampsitePlanOption.globalize_attribute_names
    )
  end

  def set_campsite_plan_option
    @campsite_plan_option = campsite_plan_options_by_current_tenant.find params[:id]
  end

  def campsite_plan_options_by_current_tenant # get campsites plan options by current tenant(supplier company)
    if current_admin_user.is_super_admin?
      CampsitePlanOption.all
    else
      CampsitePlanOption.by_campsite_id(current_tenant.campsites.pluck(:id))
    end
  end
end