class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.integer :supplier_company_id

      t.timestamps
    end
  end
end
