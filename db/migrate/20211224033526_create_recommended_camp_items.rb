class CreateRecommendedCampItems < ActiveRecord::Migration[6.1]
  def change
    create_table :recommended_camp_items do |t|
      t.references :supplier_company
      t.references :recommended_itemable, polymorphic: true
      t.integer :weight
      t.string :item_type

      t.timestamps
    end
  end
end
