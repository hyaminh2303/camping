class BookingContactInformation < ApplicationRecord
  # https://app.clickup.com/t/1xwmern
  attr_accessor :custom_number_of_male, :custom_number_of_female, :is_validate_number_of_people

  belongs_to :travel_package

  validates :address, :birthday, :email, :name,
            :phone_number, :post_code, :number_of_male, :number_of_female, presence: true
  validates :phone_number, phone: true
  validates :number_of_male, :number_of_female, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validate :validate_number_of_people

  after_validation :custom_error_messages

  def number_of_people
    number_of_male.to_i + number_of_female.to_i
  end

  private

  def validate_number_of_people
    return if !is_validate_number_of_people

    if self.travel_package.campsite_booking.number_of_people != number_of_people && !self.errors.has_key?(:number_of_male)
      self.errors.add(
        :custom_number_of_male,
        :number_of_people_different_from_reserved_number,
        message: I18n.t('activerecord.errors.messages.number_of_people_different_from_reserved_number')
      )
    end
  end

  def custom_error_messages
    if self.errors.has_key?(:number_of_male)
      self.errors.add(
        :custom_number_of_male,
        :custom_error_message_number_of_male,
        message: I18n.t("activerecord.attributes.booking_contact_information.custom_error_message_number_of_male")
      )
    end

    if self.errors.has_key?(:number_of_female)
      self.errors.add(
        :custom_number_of_female,
        :custom_error_message_number_of_female,
        message: I18n.t("activerecord.attributes.booking_contact_information.custom_error_message_number_of_female")
      )
    end
  end

end

# == Schema Information
#
# Table name: booking_contact_informations
#
#  id                :bigint           not null, primary key
#  address           :string
#  birthday          :date
#  email             :string
#  name              :string
#  number_of_female  :integer
#  number_of_male    :integer
#  phone_number      :string
#  post_code         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  travel_package_id :bigint
#
# Indexes
#
#  index_booking_contact_informations_on_travel_package_id  (travel_package_id)
#
