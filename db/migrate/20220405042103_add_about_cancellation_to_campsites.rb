class AddAboutCancellationToCampsites < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Campsite.add_translation_fields!({
          about_cancellation: :text
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        remove_column :campsite_translations, :about_cancellation
        add_column :campsites, :about_cancellation, :text
      end
    end
  end
end
