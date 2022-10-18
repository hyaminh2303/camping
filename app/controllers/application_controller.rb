class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :set_locale

  def default_url_options
    { locale: ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
  end

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def after_sign_in_path_for(resource)
    return super if resource.is_a? CustomerUser

    if resource.is_super_admin?
      admin_root_path
    elsif resource.is_campsite_admin?
      admin_campsite_root_path
    elsif resource.is_camp_car_admin?
      admin_camp_car_root_path
    else
      super
    end
  end

end
