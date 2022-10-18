class Admin::ClassificationDaySettingsController < Admin::AdminController
  before_action :set_classification_day_setting, only: %i[show edit update destroy]
  authorize_resource

  def index
    @classification_day_settings = ClassificationDaySetting.page(params[:page]).order(created_at: :desc)
  end

  def new
    @classification_day_setting = ClassificationDaySetting.new
  end

  def create
    @classification_day_setting = ClassificationDaySetting.new(classification_day_setting_params)

    if @classification_day_setting.save
      redirect_to admin_classification_day_setting_path(@classification_day_setting), notice: I18n.t("controllers.created", model: ClassificationDaySetting.model_name.human)
    else
      render :new, alert: @classification_day_setting.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @classification_day_setting.update(classification_day_setting_params)
      redirect_to admin_classification_day_setting_path(@classification_day_setting), notice: I18n.t("controllers.updated", model: ClassificationDaySetting.model_name.human)
    else
      render :edit, alert: @classification_day_setting.errors.full_messages
    end
  end

  def destroy
    @classification_day_setting.destroy
    redirect_to admin_classification_day_settings_path(), notice: I18n.t("controllers.deleted", model: ClassificationDaySetting.model_name.human)
  end

  private

  def classification_day_setting_params
    params.require(:classification_day_setting).permit(
      :color,
      :name
    )
  end

  def set_classification_day_setting
    @classification_day_setting = ClassificationDaySetting.find params[:id]
  end
end