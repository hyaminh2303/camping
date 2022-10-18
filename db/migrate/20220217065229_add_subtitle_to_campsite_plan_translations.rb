class AddSubtitleToCampsitePlanTranslations < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        CampsitePlan.add_translation_fields!({
          subtitle: :text
        }, {
          migrate_data: true,
          remove_source_columns: true
        })
      end

      dir.down do
        remove_column :campsite_plan_translations, :subtitle
        add_column :campsite_plans, :subtitle, :text
      end
    end
  end
end
