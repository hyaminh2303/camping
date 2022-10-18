class AddPeripheralFacilitiesToCampsites < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Campsite.add_translation_fields!({
          peripheral_facilities: :text
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        remove_column :campsite_translations, :peripheral_facilities
        add_column :campsites, :peripheral_facilities, :text
      end
    end
  end
end
