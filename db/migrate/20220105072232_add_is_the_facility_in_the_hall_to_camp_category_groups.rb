class AddIsTheFacilityInTheHallToCampCategoryGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_category_groups, :is_the_facility_in_the_hall, :boolean, default: false
  end
end
