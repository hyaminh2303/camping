class TranslateCampCarOptions < ActiveRecord::Migration[6.1]
  def self.up
    CampCarOption.create_translation_table!({
      name: :string,
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    CampCarOption.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
