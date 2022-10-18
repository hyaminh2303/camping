class CreateDateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :date_settings do |t|
      t.date :date
      t.references :classification_day_setting

      t.timestamps
    end
  end
end
