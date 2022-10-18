class TranslateCities < ActiveRecord::Migration[6.1]
  def self.up
    Master::City.create_translation_table!({
      name: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    Master::City.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
