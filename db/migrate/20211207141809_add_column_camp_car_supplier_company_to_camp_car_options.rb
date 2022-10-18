class AddColumnCampCarSupplierCompanyToCampCarOptions < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_car_options, :supplier_company_id, :integer
  end
end
