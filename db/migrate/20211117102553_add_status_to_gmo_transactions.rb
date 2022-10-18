class AddStatusToGmoTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :gmo_transactions, :status, :string
  end
end
