class CreateCampsiteCampCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_camp_categories do |t|
      t.references :campsite
      t.references :camp_category

      t.timestamps
    end
  end
end
