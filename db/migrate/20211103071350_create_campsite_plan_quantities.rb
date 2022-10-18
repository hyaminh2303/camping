class CreateCampsitePlanQuantities < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_quantities do |t|
      t.integer :quantity
      t.date :date

      t.references :campsite_plan

      t.timestamps
    end
  end
end
