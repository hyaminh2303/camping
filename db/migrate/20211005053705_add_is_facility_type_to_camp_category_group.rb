class AddIsFacilityTypeToCampCategoryGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_category_groups, :is_facility_type, :boolean, default: false
  end
end
