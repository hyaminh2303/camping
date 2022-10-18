class AddIsAddingCreditCardReminderSentToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_packages, :is_adding_credit_card_reminder_sent, :boolean, default: false
  end
end
