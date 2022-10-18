
module Admin
  class AdminController < ApplicationController
    set_current_tenant_through_filter
    layout 'layouts/admin_application'

    before_action :authenticate_admin_user!
    before_action :set_tenant

    def current_ability
      @current_ability ||= ::Ability.new(current_admin_user, params)
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_root_path, alert: exception.message
    end

    private

    def set_tenant
      set_current_tenant(nil)

      if current_admin_user.is_campsite_admin? || current_admin_user.is_camp_car_admin?
        set_current_tenant(current_admin_user.supplier_company)
      end
    end

  end
end