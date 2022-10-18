class AddLastNameFirstNameCountryToCustomerUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_users, :last_name, :string
    add_column :customer_users, :first_name, :string
    add_reference :customer_users, :country
  end
end
