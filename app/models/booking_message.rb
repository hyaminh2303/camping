class BookingMessage < ApplicationRecord
  belongs_to :customer_user
  belongs_to :booking_messageable, polymorphic: true
  has_many :booking_message_details, dependent: :destroy

  validates :subject, presence: true

  accepts_nested_attributes_for :booking_message_details, allow_destroy: true

  def booking_messageable_gid=(gid)
    self.booking_messageable = GlobalID::Locator.locate gid
  end
end

# == Schema Information
#
# Table name: booking_messages
#
#  id                       :bigint           not null, primary key
#  booking_messageable_type :string
#  subject                  :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  booking_messageable_id   :bigint
#  customer_user_id         :bigint
#
# Indexes
#
#  index_booking_messages_on_booking_messageable  (booking_messageable_type,booking_messageable_id)
#  index_booking_messages_on_customer_user_id     (customer_user_id)
#
