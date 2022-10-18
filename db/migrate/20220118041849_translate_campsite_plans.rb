class TranslateCampsitePlans < ActiveRecord::Migration[6.1]
  def self.up
    CampsitePlan.create_translation_table!({
      name: :string,
      description: :text
    }, {
      migrate_data: true,
      remove_source_columns: true
    })
  end

  def self.down
    CampsitePlan.drop_translation_table! migrate_data: true, create_source_columns: true
  end
end
