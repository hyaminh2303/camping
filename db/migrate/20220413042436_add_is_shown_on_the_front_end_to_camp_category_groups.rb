class AddIsShownOnTheFrontEndToCampCategoryGroups < ActiveRecord::Migration[6.1]
  def change
    # https://app.clickup.com/t/24andfw
    add_column :camp_category_groups, :is_shown_on_the_front_end, :boolean, default: true
  end
end
