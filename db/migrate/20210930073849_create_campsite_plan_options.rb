class CreateCampsitePlanOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_options do |t|
      t.decimal :price
      t.string :name

      t.timestamps
    end
  end
end
