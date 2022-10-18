class Accountant < ApplicationRecord
  include SupplierCompanyAsTenant

  validates :phone_number, phone: true

end

# == Schema Information
#
# Table name: accountants
#
#  id                  :bigint           not null, primary key
#  email               :string
#  name                :string
#  name_phonetic       :string
#  phone_number        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  supplier_company_id :bigint
#
# Indexes
#
#  index_accountants_on_supplier_company_id  (supplier_company_id)
#
