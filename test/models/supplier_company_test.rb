require "test_helper"

class SupplierCompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: supplier_companies
#
#  id                             :bigint           not null, primary key
#  company_name                   :string
#  contract_start_date            :date
#  contract_type                  :string
#  corporate_name_kana            :string
#  fax                            :string
#  hp_url                         :string
#  is_reflect_in_sales_management :boolean          default(FALSE)
#  location                       :string
#  note                           :text
#  operation_classification       :string
#  phone_number                   :string
#  post_code                      :string
#  ryokan                         :string
#  type                           :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
