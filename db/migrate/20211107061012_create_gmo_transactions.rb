class CreateGmoTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :gmo_transactions do |t|
      t.string :order_id
      t.string :acs
      t.string :forward
      t.string :method
      t.string :pay_times
      t.string :approve
      t.string :tran_id
      t.string :tran_date
      t.string :check_string
      t.float :amount
      t.integer :travel_package_id

      t.timestamps
    end
  end
end
