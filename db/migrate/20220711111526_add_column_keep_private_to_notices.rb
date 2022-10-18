class AddColumnKeepPrivateToNotices < ActiveRecord::Migration[6.1]
  def change
    add_column :notices, :keep_private, :boolean , default: false
  end
end
