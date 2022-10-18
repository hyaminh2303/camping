class Admin::CampCarSaleManagementsController < Admin::AdminController
  authorize_resource class: false

  def index
    camp_car_sale_management_service = CampCarSaleManagementService.new(params)
    @camp_cars_info = camp_car_sale_management_service.run
  end

end
