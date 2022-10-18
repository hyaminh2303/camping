class TranslateChildAndPetSettings < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        ChildAndPetSetting.create_translation_table!({
          entity_label: :string
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        ChildAndPetSetting.drop_translation_table! migrate_data: true, create_source_columns: true
      end
    end
  end
end
