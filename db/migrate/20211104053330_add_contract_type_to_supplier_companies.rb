class AddContractTypeToSupplierCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :supplier_companies, :contract_type, :string
  end
end
