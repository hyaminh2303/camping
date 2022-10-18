class AddContractTypeToCampsites < ActiveRecord::Migration[6.1]
  def up
    add_column :campsites, :contract_type, :string
  end

  def down
    remove_column :campsites, :contract_type
  end
end
