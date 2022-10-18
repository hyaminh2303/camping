class Blog < ApplicationRecord
  extend Enumerize

  I18n.available_locales.each do |locale|
    acts_as_taggable_on "tags_#{locale}"
  end

  I18n.available_locales.each do |locale|
    acts_as_taggable_on "areas_#{locale}"
  end

  has_one :photo, as: :photoable, dependent: :destroy
  belongs_to :blog_category

  accepts_nested_attributes_for :photo, reject_if: :all_blank, allow_destroy: true

  validates :title, :blog_category_id, :description, presence: true

  enumerize :blog_type, in: [:glover_blog, :supplier_blog], scope: true

  translates :title, :description, :content
  globalize_accessors locales: I18n.available_locales, attributes: [:title, :description, :content]
  globalize_validations locales: [:ja]
  validate :validates_globalized_attributes

  scope :top_page, -> { where(to_top_page: true) }
  scope :without_keep_private, -> () {where(keep_private: false)} #https://app.clickup.com/t/213ne36

  def tags_locale_list
    send "tags_#{I18n.locale}_list"
  end

  def areas_locale_list
    send "areas_#{I18n.locale}_list"
  end

end

# == Schema Information
#
# Table name: blogs
#
#  id               :bigint           not null, primary key
#  blog_type        :string
#  content          :text
#  description      :text
#  keep_private     :boolean          default(FALSE)
#  publish_date     :date
#  title            :string
#  to_top_page      :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blog_category_id :integer
#
