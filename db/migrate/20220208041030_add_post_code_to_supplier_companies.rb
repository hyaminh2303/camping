class AddPostCodeToSupplierCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :supplier_companies, :post_code, :string
  end
end
