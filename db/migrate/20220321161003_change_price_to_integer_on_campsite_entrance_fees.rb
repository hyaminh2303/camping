class ChangePriceToIntegerOnCampsiteEntranceFees < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsite_entrance_fees, :adult_fee, :integer
  end

  def self.down
    change_column :campsite_entrance_fees, :adult_fee, :decimal
  end
end
