class TranslateCampsiteOptionsIncludedInBooking < ActiveRecord::Migration[6.1]
  def self.up
    CampsiteOptionIncludedInBooking.create_translation_table!({
      name: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    CampsiteOptionIncludedInBooking.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
