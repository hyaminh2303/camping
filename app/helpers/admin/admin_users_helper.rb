module Admin::AdminUsersHelper
  def roles_data_collection
    {
      super_admin: [],
      campsite_admin_supplier_companies: CampsiteSupplierCompany.all.map{ |c| [c.id, c.company_name] },
      camp_car_admin_supplier_companies: CampCarSupplierCompany.all.map{ |c| [c.id, c.company_name] }
    }
  end
end
