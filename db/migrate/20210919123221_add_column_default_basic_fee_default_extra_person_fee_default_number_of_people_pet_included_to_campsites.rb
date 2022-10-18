class AddColumnDefaultBasicFeeDefaultExtraPersonFeeDefaultNumberOfPeoplePetIncludedToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :default_basic_fee, :decimal
    add_column :campsites, :default_extra_person_fee, :decimal
    add_column :campsites, :default_number_of_people_pet_included, :integer
  end
end
