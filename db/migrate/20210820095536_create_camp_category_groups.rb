class CreateCampCategoryGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_category_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
