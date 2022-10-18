class ChangeContractStartDateToDateOnSupplierCompany < ActiveRecord::Migration[6.1]
  def self.up
    change_column :supplier_companies, :contract_start_date, :date
  end

  def self.down
    change_column :supplier_companies, :contract_start_date, :datetime
  end
end
