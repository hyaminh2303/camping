class Notice < ApplicationRecord
  include SupplierCompanyAsTenant
  extend Enumerize

  has_one :photo, as: :photoable, dependent: :destroy
  belongs_to :notice_itemable, polymorphic: true, optional: true

  validates :title, :content, :item_type, presence: true
  validates :notice_itemable_id, presence: true, if: proc{ self.item_type != 'super_admin' }
  validates :notice_itemable_id, uniqueness: { scope: :supplier_company_id }, if: proc{ self.item_type != 'super_admin' }

  before_validation :set_notice_itemable_type
  before_validation :skip_validation_supplier_company, if: proc{ self.item_type == 'super_admin' }

  enumerize :item_type,
            in: [ :campsite, :camp_car, :super_admin ],
            predicates: { prefix: true },
            scope: true

  accepts_nested_attributes_for :photo, reject_if: :all_blank, allow_destroy: true

  translates :title, :content
  globalize_accessors locales: I18n.available_locales, attributes: [:title, :content]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0
  validate :validates_globalized_attributes

  scope :with_notice_itemable_id, ->(notice_id){ where(notice_itemable_id: notice_id) }
  scope :without_keep_private, -> { where(keep_private: false) }
  scope :order_publish_date_desc_null_last, -> { order('publish_date DESC NULLS LAST') }
  private

  def set_notice_itemable_type
    self.notice_itemable_type = {
      campsite: 'Campsite',
      camp_car: 'CampCar'
    }[item_type.to_sym]
  end

  def skip_validation_supplier_company
    _validators.delete(:supplier_company)

    _validate_callbacks.each do |callback|
      if callback.raw_filter.respond_to? :attributes
        callback.raw_filter.attributes.delete :supplier_company
      end
    end
  end

end

# == Schema Information
#
# Table name: notices
#
#  id                   :bigint           not null, primary key
#  content              :text
#  item_type            :string
#  keep_private         :boolean          default(FALSE)
#  notice_itemable_type :string
#  publish_date         :date
#  title                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  notice_itemable_id   :bigint
#  supplier_company_id  :integer
#
# Indexes
#
#  index_notices_on_notice_itemable  (notice_itemable_type,notice_itemable_id)
#
