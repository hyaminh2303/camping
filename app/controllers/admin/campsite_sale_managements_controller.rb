class Admin::CampsiteSaleManagementsController < Admin::AdminController
  authorize_resource class: false

  def index
    campsite_sale_management_service = CampsiteSaleManagementServiceNew.new(params, current_admin_user)
    @campsites_info = campsite_sale_management_service.run
  end

end
