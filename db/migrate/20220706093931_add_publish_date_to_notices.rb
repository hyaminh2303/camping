class AddPublishDateToNotices < ActiveRecord::Migration[6.1]
  def change
    add_column :notices, :publish_date, :date
  end
end
