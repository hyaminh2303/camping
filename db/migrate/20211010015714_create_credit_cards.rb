class CreateCreditCards < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_cards do |t|
      t.integer :exp_month
      t.integer :exp_year
      t.string :last4
      t.string :card_holder_name
      t.integer :customer_user_id

      t.timestamps
    end
  end
end
