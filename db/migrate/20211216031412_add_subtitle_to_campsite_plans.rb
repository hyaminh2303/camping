class AddSubtitleToCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plans, :subtitle, :text
  end
end
