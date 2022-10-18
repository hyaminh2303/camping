class CreateCampsitePlanDailyFeeSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_daily_fee_settings do |t|
      t.integer :campsite_plan_id
      t.decimal :basic_fee
      t.integer :number_of_people_pet_included
      t.decimal :extra_person_fee
      t.date :date

      t.timestamps
    end
  end
end
