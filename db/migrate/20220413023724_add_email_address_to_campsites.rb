class AddEmailAddressToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :email_address, :string
  end
end
