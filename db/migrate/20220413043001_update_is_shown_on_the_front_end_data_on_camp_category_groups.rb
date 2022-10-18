class UpdateIsShownOnTheFrontEndDataOnCampCategoryGroups < ActiveRecord::Migration[6.1]
  def change
    # https://app.clickup.com/t/24andfw
    camp_category_group = CampCategoryGroup.with_translations(:ja).find_by(name: '近隣施設')
    if camp_category_group.present?
      camp_category_group.update_column(:is_shown_on_the_front_end, false)
    end
  end
end
