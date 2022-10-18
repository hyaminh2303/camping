class AddFaxToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :fax, :string
  end
end
