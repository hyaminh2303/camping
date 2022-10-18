class RenameColumnAdultFeeAndQuantityInCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def change
    rename_column :campsite_plan_fee_details, :adult_fee, :basic_fee
    rename_column :campsite_plan_fee_details, :quantity, :number_of_people_pet_included
  end
end
