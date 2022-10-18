class AddSubtitleTranslationToCampCars < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        CampCar.add_translation_fields!({
          subtitle: :text
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        remove_column :camp_car_translations, :subtitle
        add_column :camp_cars, :subtitle, :text
      end
    end
  end
end
