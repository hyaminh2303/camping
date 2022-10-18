class AddPostCodeAdrressToCustomerUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_users, :post_code, :string
    add_column :customer_users, :address, :string
  end
end
