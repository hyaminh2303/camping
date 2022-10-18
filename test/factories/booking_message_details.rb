FactoryBot.define do
  factory :booking_message_detail do
    booking_message { nil }
    message { "MyString" }
  end
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
