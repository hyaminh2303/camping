class ActualSaleProcessor
  def initialize; end

  def run
    GmoTransaction.by_temporary_sale.with_booked_status.each do |gmo_transaction|
      travel_package = gmo_transaction.travel_package

      begin
        if start_date_of(travel_package) < PaymentProcessor::NUMBER_OF_DAY_FOR_ACTUAL_SALE.days.from_now.end_of_day
          update_to_actual_sale_for(gmo_transaction)
          gmo_transaction.update(status: PaymentProcessor::ACTUAL_SALE)
        end

      rescue => e
        AdminUserMailer.update_to_actual_sale_for_gmo_transaction_failed(gmo_transaction, e).deliver_now
      end
    end
  end

  private

  def start_date_of(travel_package)
    if travel_package.booking_type_campsite_booking?
      travel_package.campsite_booking.check_in
    elsif travel_package.booking_type_camp_car_booking?
      travel_package.camp_car_booking.start_date_of_renting
    else
      # To do ...
    end
  end

  def update_to_actual_sale_for(gmo_transaction)
    travel_package = gmo_transaction.travel_package

    transaction = GMO::Shop::Transaction.new(
      travel_package,
      customer_user: travel_package.customer_user
    )

    transaction.perform_actual_sale_for(gmo_transaction)
  end

end