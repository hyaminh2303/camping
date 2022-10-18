class TranslateChildAndPetIncludedInBookings < ActiveRecord::Migration[6.1]
  def self.up
    ChildAndPetIncludedInBooking.create_translation_table!({
      entity_label: :string
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    ChildAndPetIncludedInBooking.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
