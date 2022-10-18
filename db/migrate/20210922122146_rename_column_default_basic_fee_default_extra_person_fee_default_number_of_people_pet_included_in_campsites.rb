class RenameColumnDefaultBasicFeeDefaultExtraPersonFeeDefaultNumberOfPeoplePetIncludedInCampsites < ActiveRecord::Migration[6.1]
  def change
    rename_column :campsites, :default_basic_fee, :basic_fee
    rename_column :campsites, :default_extra_person_fee, :extra_person_fee
    rename_column :campsites, :default_number_of_people_pet_included, :number_of_people_pet_included
  end
end
