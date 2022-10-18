class AddNoteToSupplierCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :supplier_companies, :note, :text
  end
end
