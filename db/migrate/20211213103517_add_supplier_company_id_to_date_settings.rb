class AddSupplierCompanyIdToDateSettings < ActiveRecord::Migration[6.1]
  def change
    add_reference :date_settings, :supplier_company
  end
end
