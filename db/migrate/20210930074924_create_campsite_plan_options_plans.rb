class CreateCampsitePlanOptionsPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_options_plans do |t|
      t.integer :campsite_plan_id
      t.integer :campsite_plan_option_id

      t.timestamps
    end
  end
end
