class CreateCampsitePlanFeesClassificationDaySettings < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_fees_classification_day_settings do |t|
      t.integer :campsite_plan_fee_id
      t.integer :classification_day_setting_id

      t.timestamps
    end
  end
end
