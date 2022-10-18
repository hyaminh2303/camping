class CreateCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plans do |t|
      t.integer :campsite_id
      t.string :name
      t.text :description
      t.integer :max_number_of_people
      t.integer :people_type
      t.boolean :public_info
      t.string :publication_period
      t.time :check_in_time
      t.time :check_out_time

      t.timestamps
    end
  end
end
