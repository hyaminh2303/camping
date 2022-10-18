class TranslateCampCategories < ActiveRecord::Migration[6.1]
  def self.up
    CampCategory.create_translation_table!({
      name: :string,
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    CampCategory.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
