class RenameBookingExpiredAtToCreditCardAdditionExpiredAtForTravelPackages < ActiveRecord::Migration[6.1]
  def change
    rename_column :travel_packages, :booking_expired_at, :credit_card_addition_expired_at
  end
end
