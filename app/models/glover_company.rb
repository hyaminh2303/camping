class GloverCompany < ApplicationRecord
  acts_as_singleton

  validates :company_name, :location, :phone_number, :hp_url, presence: true
  validates :phone_number, phone: true

end

# == Schema Information
#
# Table name: glover_companies
#
#  id           :bigint           not null, primary key
#  company_name :string
#  hp_url       :string
#  location     :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
