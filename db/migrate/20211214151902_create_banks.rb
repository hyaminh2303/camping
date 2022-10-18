class CreateBanks < ActiveRecord::Migration[6.1]
  def change
    create_table :banks do |t|
      t.string :name
      t.string :branch_name
      t.string :account_type
      t.string :account_number
      t.string :account_holder
      t.string :bankable_type
      t.integer :bankable_id

      t.timestamps
    end
  end
end
