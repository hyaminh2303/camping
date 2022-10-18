class RemoveSupplierCompanyIdFromDateSettings < ActiveRecord::Migration[6.1]
  def change
    remove_reference :date_settings, :supplier_company
  end
end
