class CreateClassificationDaySettings < ActiveRecord::Migration[6.1]
  def change
    create_table :classification_day_settings do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
