class AddContractTypeToCampCars < ActiveRecord::Migration[6.1]
  def up
    add_column :camp_cars, :contract_type, :string
  end

  def down
    remove_column :camp_cars, :contract_type
  end
end
