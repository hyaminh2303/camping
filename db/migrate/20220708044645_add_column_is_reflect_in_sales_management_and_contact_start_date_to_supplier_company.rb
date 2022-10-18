class AddColumnIsReflectInSalesManagementAndContactStartDateToSupplierCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :supplier_companies, :is_reflect_in_sales_management, :boolean, default: false
    add_column :supplier_companies, :contract_start_date, :datetime
  end
end
