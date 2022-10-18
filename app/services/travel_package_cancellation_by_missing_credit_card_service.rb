class TravelPackageCancellationByMissingCreditCardService
  def self.run
    TravelPackage.includes(:campsite_booking, :camp_car_booking).with_status(:booked).
    with_payment_method(:credit_card).without_gmo_transaction.each do |travel_package|
      if !travel_package.is_check_in_date_started_after_60_days_from_now? &&
        travel_package.credit_card_addition_expired_at.present? &&
        travel_package.credit_card_addition_expired_at < Time.current

        travel_package.update(
          status: :canceled,
          canceled_at: Time.current,
          canceled_by: travel_package.booked_by
        )

      end
    end

  end
end