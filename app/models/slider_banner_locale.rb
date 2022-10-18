class SliderBannerLocale < ApplicationRecord
  extend Enumerize

  belongs_to :slider_banner
  has_many :photos, as: :photoable, dependent: :destroy
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  enumerize :locale, in: I18n.available_locales, scope: true, predicates: {prefix: true}

  validates :photos, presence: true, if: proc { |x| x.locale == :ja }
  validates :locale, presence: true
  validates :locale, uniqueness: { scope: :slider_banner }
end

# == Schema Information
#
# Table name: slider_banner_locales
#
#  id               :bigint           not null, primary key
#  locale           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  slider_banner_id :bigint
#
# Indexes
#
#  index_slider_banner_locales_on_slider_banner_id  (slider_banner_id)
#
