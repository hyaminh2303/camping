class RemoveContractTypeFromCampCars < ActiveRecord::Migration[6.1]
  def change
    remove_column :camp_cars, :contract_type, :string
  end
end
