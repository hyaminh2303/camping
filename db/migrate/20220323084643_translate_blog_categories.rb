class TranslateBlogCategories < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        BlogCategory.create_translation_table!({
          name: :string
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        BlogCategory.drop_translation_table! migrate_data: true, create_source_columns: true
      end
    end
  end
end
