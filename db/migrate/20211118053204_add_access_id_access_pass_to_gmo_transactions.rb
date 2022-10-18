class AddAccessIdAccessPassToGmoTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :gmo_transactions, :access_id, :string
    add_column :gmo_transactions, :access_pass, :string
  end
end
