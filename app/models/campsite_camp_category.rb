class CampsiteCampCategory < ApplicationRecord
  belongs_to :campsite
  belongs_to :camp_category

  scope :by_camp_categories, -> (camp_category_ids) { where(camp_category_id: camp_category_ids) }
end

# == Schema Information
#
# Table name: campsite_camp_categories
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  camp_category_id :bigint
#  campsite_id      :bigint
#
# Indexes
#
#  index_campsite_camp_categories_on_camp_category_id  (camp_category_id)
#  index_campsite_camp_categories_on_campsite_id       (campsite_id)
#
