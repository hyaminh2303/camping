class RemoveCorporateCategoryFromSupplierCompanies < ActiveRecord::Migration[6.1]
  def change
    remove_column :supplier_companies, :corporate_category, :string
  end
end
