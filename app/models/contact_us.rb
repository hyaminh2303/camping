class ContactUs < ApplicationRecord
  validates :name, :email, :phone_number, :details_of_inquiry, presence: true
  validates :phone_number, phone: true

end

# == Schema Information
#
# Table name: contact_us
#
#  id                 :bigint           not null, primary key
#  details_of_inquiry :text
#  email              :string
#  name               :string
#  phone_number       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
