require "test_helper"

class SupplierContactInformationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: supplier_contact_informations
#
#  id                               :bigint           not null, primary key
#  accounting_personnel_information :string
#  email_address                    :string
#  fax                              :string
#  location                         :string
#  name_of_person_in_charge         :string
#  person_in_charge_name_kana       :string
#  phone_number                     :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  supplier_company_id              :integer
#
