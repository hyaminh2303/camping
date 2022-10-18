class AddBirthdayPhoneNumberToCustomerUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_users, :birthday, :date
    add_column :customer_users, :phone_number, :string
  end
end
