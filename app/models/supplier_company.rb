class SupplierCompany < ApplicationRecord
  extend Enumerize

  has_one :supplier_corporate_representative_information, dependent: :destroy
  has_one :supplier_contact_information, dependent: :destroy
  has_one :accountant, dependent: :destroy

  accepts_nested_attributes_for :supplier_corporate_representative_information
  accepts_nested_attributes_for :supplier_contact_information
  accepts_nested_attributes_for :accountant

  scope :with_type, -> (type) { where(type: type) }

  enumerize :contract_type,
            in: [:commission_base, :no_commission],
            predicates: { prefix: true },
            scope: true,
            i18n_scope: 'activerecord.enum.supplier_company.contract_type'

  enumerize :operation_classification,
            in: [:private_management, :pubic_management],
            predicates: { prefix: true },
            scope: true,
            i18n_scope: 'activerecord.enum.supplier_company.operation_classification'

  enumerize :ryokan,
            in: [:yes, :no],
            predicates: { prefix: true },
            scope: true,
            i18n_scope: 'activerecord.enum.supplier_company.ryokan'

  validates :contract_type, :operation_classification, presence: true
  validates :phone_number, phone: true
  validates :contract_start_date, presence: true, if: proc { is_reflect_in_sales_management }

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
