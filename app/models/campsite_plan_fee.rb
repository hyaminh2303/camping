class CampsitePlanFee < ApplicationRecord
  has_one :normal_campsite_plan_fee_detail,
          class_name: 'CampsitePlanFeeDetail',
          foreign_key: :normal_campsite_plan_fee_id,
          dependent: :destroy,
          inverse_of: :normal_campsite_plan_fee

  has_many :classification_day_campsite_plan_fee_details,
           class_name: 'CampsitePlanFeeDetail',
           foreign_key: :classification_day_campsite_plan_fee_id,
           dependent: :destroy,
           inverse_of: :classification_day_campsite_plan_fee

  has_many :normal_child_and_pet_fees,
          class_name: 'ChildAndPetFee',
          foreign_key: :normal_campsite_plan_fee_id,
          dependent: :destroy,
          inverse_of: :normal_campsite_plan_fee

  has_many :classification_day_child_and_pet_fees,
           class_name: 'ChildAndPetFee',
           foreign_key: :classification_day_campsite_plan_fee_id,
           dependent: :destroy,
           inverse_of: :classification_day_campsite_plan_fee

  belongs_to :campsite_plan
  has_and_belongs_to_many :classification_day_settings

  accepts_nested_attributes_for :normal_campsite_plan_fee_detail, allow_destroy: true
  accepts_nested_attributes_for :classification_day_campsite_plan_fee_details, allow_destroy: true
  accepts_nested_attributes_for :normal_child_and_pet_fees, allow_destroy: true
  accepts_nested_attributes_for :classification_day_child_and_pet_fees, allow_destroy: true

  enum fee_type: [:normal, :classification_day]

  validates_associated :normal_campsite_plan_fee_detail
  validates_associated :classification_day_campsite_plan_fee_details
  validates_associated :normal_child_and_pet_fees
  validates_associated :classification_day_child_and_pet_fees
  validates :start_date, :end_date, presence: true, if: -> { normal? }
  validates_date :end_date, after: :start_date, if: -> { normal? }

  scope :by_start_date_and_end_date, -> (start_date, end_date) { where('start_date <= ? AND end_date >= ?', start_date, end_date) }

  def fee_type_text
    I18n.t("activerecord.enum.campsite_plan_fee.fee_type.#{fee_type}")
  end

end

# == Schema Information
#
# Table name: campsite_plan_fees
#
#  id               :bigint           not null, primary key
#  end_date         :datetime
#  fee_type         :integer
#  start_date       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campsite_plan_id :integer
#
