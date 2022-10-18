class RecommendedCampItem < ApplicationRecord
  attr_accessor :recommended_campsite, :recommended_camp_car

  extend Enumerize
  include SupplierCompanyAsTenant

  MAX_NUMBER_OF_WEIGHT = 100000

  belongs_to :recommended_itemable, polymorphic: true

  validates :weight, :item_type, :recommended_itemable_id, presence: true
  validates :recommended_itemable_id, uniqueness: { scope: :supplier_company_id }
  validates :weight, numericality: { greater_than: 0 }

  before_validation :set_recommended_itemable_type
  after_validation :custom_error_message

  enumerize :item_type,
            in: [:campsite, :camp_car],
            predicates: { prefix: true },
            scope: true

  # scope: with_item_type(item_type) => is generated from enumerize has 'scope: true' as the above
  scope :order_by, -> (item_type, direction) {
    includes(:recommended_itemable).
    with_item_type(item_type).
    order(weight: direction)
  }

  private

  def set_recommended_itemable_type
    self.recommended_itemable_type = {
      campsite: 'Campsite',
      camp_car: 'CampCar'
    }[item_type.to_sym]
  end

  def custom_error_message
    self.errors.full_messages_for(:recommended_itemable_id).each do |message|
      key = {
        campsite: :recommended_campsite,
        camp_car: :recommended_camp_car
      }[item_type.to_sym]

      self.errors.add(key, message)
    end
  end

end

# == Schema Information
#
# Table name: recommended_camp_items
#
#  id                        :bigint           not null, primary key
#  item_type                 :string
#  recommended_itemable_type :string
#  weight                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  recommended_itemable_id   :bigint
#  supplier_company_id       :bigint
#
# Indexes
#
#  index_recommended_camp_items_on_recommended_itemable  (recommended_itemable_type,recommended_itemable_id)
#  index_recommended_camp_items_on_supplier_company_id   (supplier_company_id)
#
