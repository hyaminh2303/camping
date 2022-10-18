class AddSupplierToForTenancy < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :supplier_company_id, :integer
    add_column :camp_cars, :supplier_company_id, :integer
    add_column :campsites, :supplier_company_id, :integer
  end
end
