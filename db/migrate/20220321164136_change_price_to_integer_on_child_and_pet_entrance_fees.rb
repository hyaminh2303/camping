class ChangePriceToIntegerOnChildAndPetEntranceFees < ActiveRecord::Migration[6.1]
  def self.up
    change_column :child_and_pet_entrance_fees, :fee_value, :integer, default: 0
  end

  def self.down
    change_column :child_and_pet_entrance_fees, :fee_value, :decimal, default: 0.0
  end
end
