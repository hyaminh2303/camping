class RemoveSupplierCompanyIdFromCampsitePlanOptions < ActiveRecord::Migration[6.1]
  def change
    remove_reference :campsite_plan_options, :supplier_company
  end
end
