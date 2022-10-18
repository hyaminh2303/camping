class CreateJapanesePublicHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :japanese_public_holidays do |t|
      t.date :date
      t.string :name

      t.timestamps
    end
  end
end
