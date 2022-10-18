class AddCodeToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :code, :string
  end
end
