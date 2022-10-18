class CreateCampsitePlanFees < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_fees do |t|
      t.integer :campsite_plan_id
      t.integer :fee_type
      t.integer :priority
      t.text :day_names
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
