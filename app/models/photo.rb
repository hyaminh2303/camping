class Photo < ApplicationRecord
  belongs_to :photoable, polymorphic: true

  mount_uploader :image, ImageUploader

  validates :image, presence: true
  validates :on_click_url, url: { allow_blank: true }

  validates :image, format: { with: %r{\.(png|jpg|jpeg)\z}i, message: I18n.t('activerecord.errors.messages.validate_image_file_type') },
                    if: proc { image.present? }

end

# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  image          :string
#  on_click_url   :string
#  photoable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  photoable_id   :bigint
#
# Indexes
#
#  index_photos_on_photoable  (photoable_type,photoable_id)
#
