class SupplierCorporateRepresentativeInformation < ApplicationRecord
  include SupplierCompanyAsTenant
end

# == Schema Information
#
# Table name: supplier_corporate_representative_informations
#
#  id                          :bigint           not null, primary key
#  email_address               :string
#  name_of_representative      :string
#  name_of_representative_kana :string
#  position                    :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  supplier_company_id         :integer
#
