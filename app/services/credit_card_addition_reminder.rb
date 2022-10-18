class CreditCardAdditionReminder
  def initialize; end

  def run
    TravelPackage.includes(:campsite_booking, :camp_car_booking).with_status(:booked).
    with_payment_method(:credit_card).without_gmo_transaction.without_adding_credit_card_reminder.each do |travel_package|
      if travel_package.is_check_in_date_started_from_3_days_to_60_days_from_now?
        travel_package.update(
          credit_card_addition_expired_at: Time.current + 3.days,
          is_adding_credit_card_reminder_sent: true
        )

        travel_package.mailer.send_credit_card_detail_url_email(travel_package).deliver_now
      end
    end

  end
end