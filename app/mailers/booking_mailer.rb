class BookingMailer < ApplicationMailer
  def send_actual_sale_email_to_customer(travel_package)
    raise "Need to be implemented"
  end

  def send_actual_sale_email_to_admin(travel_package)
    raise "Need to be implemented"
  end

  def send_temporary_sale_email_to_customer(travel_package)
    raise "Need to be implemented"
  end

  def send_temporary_sale_email_to_admin(travel_package)
    raise "Need to be implemented"
  end

  def send_booking_cancellation_confirmation_to_customer(travel_package)
    raise "Need to be implemented"
  end

  def send_booking_cancellation_confirmation_to_admin(travel_package)
    raise "Need to be implemented"
  end

  def send_temporary_sale_email_without_credit_card_to_customer(customer_user)
    raise "Need to be implemented"
  end


  def send_credit_card_detail_url_email(travel_package)
    raise "Need to be implemented"
  end
end