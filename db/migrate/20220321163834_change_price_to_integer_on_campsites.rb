class ChangePriceToIntegerOnCampsites < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsites, :basic_fee, :integer
    change_column :campsites, :extra_person_fee, :integer
  end

  def self.down
    change_column :campsites, :basic_fee, :decimal
    change_column :campsites, :extra_person_fee, :decimal
  end
end
