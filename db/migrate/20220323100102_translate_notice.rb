class TranslateNotice < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Notice.create_translation_table!({
          title: :string,
          content: :text
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        Notice.drop_translation_table! migrate_data: true, create_source_columns: true
      end
    end
  end
end
