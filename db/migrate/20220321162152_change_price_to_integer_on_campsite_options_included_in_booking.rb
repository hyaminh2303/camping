class ChangePriceToIntegerOnCampsiteOptionsIncludedInBooking < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsite_options_included_in_booking, :price, :integer
  end

  def self.down
    change_column :campsite_options_included_in_booking, :price, :decimal
  end
end
