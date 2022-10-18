class RemoveChildEntranceFeeFromCampsiteEntranceFees < ActiveRecord::Migration[6.1]
  def change
    remove_column :campsite_entrance_fees, :child_high_school_fee, :decimal
    remove_column :campsite_entrance_fees, :child_junior_high_school_fee, :decimal
    remove_column :campsite_entrance_fees, :child_primary_school_fee, :decimal
    remove_column :campsite_entrance_fees, :child_under_five_years_old_fee, :decimal
    remove_column :campsite_entrance_fees, :pet_fee, :decimal
  end
end
