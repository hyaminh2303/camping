class BlogCategory < ApplicationRecord
  extend Enumerize

  mount_uploader :icon, ImageUploader

  has_many :blogs, dependent: :destroy

  validates :name, :icon, :category_type, presence: true
  validates :icon, format: { with: %r{\.(png|jpg|jpeg)\z}i, message: I18n.t('activerecord.errors.messages.validate_image_file_type') },
                    if: proc { icon.present? }
  validate :validates_globalized_attributes

  enumerize :category_type, in: [:glover_blog, :supplier_blog], scope: true
  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja]
end

# == Schema Information
#
# Table name: blog_categories
#
#  id               :bigint           not null, primary key
#  category_type    :string
#  icon             :string
#  name             :string
#  publish          :boolean          default(FALSE)
#  weight           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blog_category_id :bigint           not null
#
