class CampsiteContentPhoto < ApplicationRecord
  belongs_to :campsite
  has_one :photo, as: :photoable, dependent: :destroy

  accepts_nested_attributes_for :photo
end

# == Schema Information
#
# Table name: campsite_content_photos
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campsite_id :bigint
#
# Indexes
#
#  index_campsite_content_photos_on_campsite_id  (campsite_id)
#
