class Admin::DateSettingsController < Admin::AdminController
  before_action :set_date_setting, only: %i[update]
  before_action :set_campsite_supplier_company_and_campsite, only: %i[index create_or_update_by_day_of_week]
  authorize_resource

  def index
    @date_settings = @campsite.date_settings
  end

  def create
    @date_setting = DateSetting.new(date_setting_params)
    supplier_company_id = @date_setting.campsite.supplier_company_id if current_admin_user.is_super_admin?

    if @date_setting.save
      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                      campsite_id: @date_setting.campsite_id),
                    notice: I18n.t("controllers.created", model: DateSetting.model_name.human)
    else
      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                    campsite_id: @date_setting.campsite_id),
                  alert: @date_setting.errors.full_messages
    end
  end

  def update
    supplier_company_id = @date_setting.campsite.supplier_company_id if current_admin_user.is_super_admin?

    if @date_setting.update(date_setting_params)
      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                      campsite_id: @date_setting.campsite_id ),
                    notice: I18n.t("controllers.updated", model: DateSetting.model_name.human)
    else
      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                      campsite_id: @date_setting.campsite_id),
                    alert: @date_setting.errors.full_messages
    end
  end

  def create_or_update_by_day_of_week
    supplier_company_id = @campsite.supplier_company_id if current_admin_user.is_super_admin?
    errors = []

    [:start_date, :end_date, :days_name].each do |item|
      errors << t("admin.date_settings.index.error_messages.blank.#{item}") if params[item].blank?
    end

    if errors.count.zero?
      start_date = params[:start_date].to_date
      end_date = params[:end_date].to_date

      dates = (start_date..end_date).select do |date|
        params[:days_name].include?(date.strftime('%A').downcase)
      end

      dates.each do |date|
        date_setting = DateSetting.find_or_initialize_by(
                                    date: date,
                                    campsite: @campsite
                                  )

        date_setting.classification_day_setting_id = params[:classification_day_setting_id]
        date_setting.save
      end

      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                    campsite_id: @campsite.id),
                  notice: t('admin.date_settings.index.messages.successfully')
    else
      redirect_back fallback_location: admin_date_settings_path(campsite_supplier_company_id: supplier_company_id,
                    campsite_id: @campsite.id),
                  alert: errors.join(', ')
    end
  end

  private

  def date_setting_params
    params.require(:date_setting).permit(
      :date,
      :classification_day_setting_id,
      :campsite_id
    )
  end

  def set_date_setting
    @date_setting = DateSetting.find params[:id]
  end

  def set_campsite_supplier_company_and_campsite
    @campsite_supplier_company = if current_admin_user.is_super_admin?
      if params[:campsite_supplier_company_id].present?
        CampsiteSupplierCompany.find(params[:campsite_supplier_company_id])
      else
        CampsiteSupplierCompany.includes(:campsites).find{ |c| c.campsites.present? }
      end
    else
      current_tenant
    end

    @campsite = @campsite_supplier_company.campsites.find_by(id: params[:campsite_id]) ||
                @campsite_supplier_company.campsites.first

    redirect_to_if_blank_campsite
  end

  def redirect_to_if_blank_campsite
    if @campsite.blank?
      redirect_back fallback_location: admin_root_path, alert: t('admin.date_settings.index.error_messages.blank_campsite')
    end
  end
end
