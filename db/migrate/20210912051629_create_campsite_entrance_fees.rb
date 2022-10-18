class CreateCampsiteEntranceFees < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_entrance_fees do |t|
      t.integer :campsite_id
      t.decimal :adult_fee,                      dafault: 0
      t.decimal :child_high_school_fee,          dafault: 0
      t.decimal :child_junior_high_school_fee,   dafault: 0
      t.decimal :child_primary_school_fee,       dafault: 0
      t.decimal :child_under_five_years_old_fee, dafault: 0
      t.decimal :pet_fee,                        dafault: 0

      t.timestamps
    end
  end
end
