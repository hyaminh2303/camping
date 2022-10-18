class CreateCampCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_categories do |t|
      t.string :name
      t.references :camp_category_group

      t.timestamps
    end
  end
end
