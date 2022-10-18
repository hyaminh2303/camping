class BookingMessageDetail < ApplicationRecord
  belongs_to :booking_message
  belongs_to :owner, polymorphic: true

  validates :message, presence: true

  default_scope { order(created_at: :asc) }

end

# == Schema Information
#
# Table name: booking_message_details
#
#  id                 :bigint           not null, primary key
#  message            :text
#  owner_type         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  booking_message_id :bigint
#  owner_id           :bigint
#
# Indexes
#
#  index_booking_message_details_on_booking_message_id  (booking_message_id)
#  index_booking_message_details_on_owner               (owner_type,owner_id)
#
