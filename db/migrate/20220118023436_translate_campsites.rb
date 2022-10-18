class TranslateCampsites < ActiveRecord::Migration[6.1]
  def self.up
    Campsite.create_translation_table!({
      name: :string,
      address: :string,
      business_information: :text,
      description: :text
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    Campsite.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
