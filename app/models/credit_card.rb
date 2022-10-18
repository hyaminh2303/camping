class CreditCard < ApplicationRecord
  attr_accessor :number, :cvc, :credit_card_token

  belongs_to :customer_user

  validates :exp_year, :exp_month, presence: true
  validates :card_holder_name, :cvc, :number, presence: true

  validates_length_of :exp_month, minimum: 1, maximum: 2, allow_blank: true
  validates_length_of :exp_year, is: 4, allow_blank: true
  validate :validate_expiration_date_is_not_in_the_past

  private

  def validate_expiration_date_is_not_in_the_past
    return unless valid_date?(expiration_date)
    if expiration_date.to_date.end_of_month.past?
      self.errors[:exp_month] << "expired"
    end
  end

  def valid_date?( str, format="%m/%Y" )
    Date.strptime(str, format).is_a?(Date) rescue false
  end

  def expiration_date
    return unless exp_month.present? && exp_year.present?
    "#{exp_month.to_s.rjust(2, '0')}/#{exp_year}"
  end
end

# == Schema Information
#
# Table name: credit_cards
#
#  id               :bigint           not null, primary key
#  card_holder_name :string
#  exp_month        :integer
#  exp_year         :integer
#  last4            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_user_id :integer
#
