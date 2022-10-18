class SliderBanner < ApplicationRecord
  enum page: [:home]

  has_many :slider_banner_locales, dependent: :destroy
  accepts_nested_attributes_for :slider_banner_locales, allow_destroy: true

  validates :page, uniqueness: true

  def self.latest_by(page)
    page = all.send(page).take
    page.slider_banner_locales.with_locale(I18n.locale).take if page
  end
end

# == Schema Information
#
# Table name: slider_banners
#
#  id         :bigint           not null, primary key
#  page       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
