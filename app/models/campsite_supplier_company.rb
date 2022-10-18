class CampsiteSupplierCompany < SupplierCompany
  has_many :campsites, foreign_key: :supplier_company_id, dependent: :destroy

  scope :by_id, -> (ids) { where(id: ids) }
  scope :recent, -> { order(company_name: :asc) }
  scope :by_month_of_contract, -> (month) { where('extract(month from contract_start_date) = ?', month) }
  scope :by_year_of_contract, -> (year) { where('extract(year from contract_start_date) = ?', year) }
  scope :only_reflect_in_sales_management, -> { where(is_reflect_in_sales_management: true) }

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
