class GmoTransaction < ApplicationRecord
  belongs_to :travel_package

  scope :by_temporary_sale, -> () { where(status: PaymentProcessor::TEMPORARY_SALE) }
  scope :by_validate_card, -> () { where(status: PaymentProcessor::VALIDATE_CARD) }
  scope :with_booked_status, -> { includes(:travel_package).where(travel_package: {status: :booked}) }

end

# == Schema Information
#
# Table name: gmo_transactions
#
#  id                :bigint           not null, primary key
#  access_pass       :string
#  acs               :string
#  amount            :float
#  approve           :string
#  check_string      :string
#  forward           :string
#  method            :string
#  pay_times         :string
#  status            :string
#  tran_date         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  access_id         :string
#  order_id          :string
#  tran_id           :string
#  travel_package_id :integer
#
