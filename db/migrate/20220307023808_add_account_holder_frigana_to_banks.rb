class AddAccountHolderFriganaToBanks < ActiveRecord::Migration[6.1]
  def change
    add_column :banks, :account_holder_frigana, :string
  end
end
