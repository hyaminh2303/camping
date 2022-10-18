class AddNoticeItemableItemTypeToNotices < ActiveRecord::Migration[6.1]
  def change
    add_reference :notices, :notice_itemable, polymorphic: true
    add_column :notices, :item_type, :string
  end
end
