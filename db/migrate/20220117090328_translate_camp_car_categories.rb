class TranslateCampCarCategories < ActiveRecord::Migration[6.1]
  def self.up
    CampCarCategory.create_translation_table!({
      model: :string,
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    CampCarCategory.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
