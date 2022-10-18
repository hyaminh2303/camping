class Admin::ChildAndPetSettingsController < Admin::AdminController
  before_action :set_child_and_pet_setting, only: %i[show edit update destroy]
  authorize_resource

  def index
    @child_and_pet_settings = child_and_pet_settings_by_current_tenant.page(params[:page]).order(created_at: :desc)
  end

  def new
    @child_and_pet_setting = ChildAndPetSetting.new
  end

  def create
    @child_and_pet_setting = ChildAndPetSetting.new(child_and_pet_setting_params)

    if @child_and_pet_setting.save
      redirect_to admin_child_and_pet_setting_path(@child_and_pet_setting), notice: I18n.t("controllers.created", model: ChildAndPetSetting.model_name.human)
    else
      render :new, alert: @child_and_pet_setting.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @child_and_pet_setting.update(child_and_pet_setting_params)
      redirect_to admin_child_and_pet_setting_path(@child_and_pet_setting), notice: I18n.t("controllers.updated", model: ChildAndPetSetting.model_name.human)
    else
      render :edit, alert: @child_and_pet_setting.errors.full_messages
    end
  end

  def destroy
    @child_and_pet_setting.destroy
    redirect_to admin_child_and_pet_settings_path(), notice: I18n.t("controllers.deleted", model: ChildAndPetSetting.model_name.human)
  end

  private

  def child_and_pet_setting_params
    params.require(:child_and_pet_setting).permit([
        :campsite_id,
        :entity_type
      ] + ChildAndPetSetting.globalize_attribute_names
    )
  end

  def set_child_and_pet_setting
    @child_and_pet_setting = child_and_pet_settings_by_current_tenant.find params[:id]
  end

  def child_and_pet_settings_by_current_tenant # get child and pet settings by current tenant(supplier company)
    if current_admin_user.is_super_admin?
      ChildAndPetSetting.all
    else
      ChildAndPetSetting.by_campsite_id(current_tenant.campsites.pluck(:id))
    end
  end
end