class PaymentProcessor
  ACTUAL_SALE = "ACTUAL_SALE"
  TEMPORARY_SALE = "TEMPORARY_SALE"
  VALIDATE_CARD = "VALIDATE_CARD"

  NUMBER_OF_DAY_FOR_ACTUAL_SALE = 3
  NUMBER_OF_DAY_FOR_TEMPORARY_SALE = 60

  attr_reader :customer_user, :current_travel_package, :credit_card,
              :run_success, :message, :error_code

  def initialize(customer_user, credit_card, current_travel_package)
    @customer_user = customer_user
    @credit_card = credit_card
    @current_travel_package = current_travel_package
  end


  def process
    begin
      gmo_transaction = GMO::Shop::Transaction.new(
        current_travel_package,
        credit_card_instance: credit_card,
        customer_user: customer_user
      )

      gmo_response =  if sale_status == ACTUAL_SALE
                        gmo_transaction.perform_actual_sale_directly
                      elsif sale_status == TEMPORARY_SALE
                        gmo_transaction.perform_temporary_sale
                      else

                      end

      create_internal_gmo_transaction(gmo_response)
      current_travel_package.mark_status_as_booked

      @run_success = true
      return self
    rescue GMO::Payment::APIError => e
      # puts e.response_body
      # => ErrCode=hoge&ErrInfo=hoge&ErrMessage=hoge
      # puts e.error_info
      # => {"ErrCode"=>"hoge", "ErrInfo"=>"hoge", "ErrMessage"=>"hoge"}
      @run_success = false

      @message = e.error_info['ErrMessage']
      @error_code = e.error_info['ErrCode']
      return self
    end
  end

  private

  def create_internal_gmo_transaction(gmo_response)
    GmoTransaction.create(
      acs: gmo_response['ACS'],
      order_id: gmo_response['OrderID'],
      forward: gmo_response['Forward'],
      method: gmo_response['Method'],
      pay_times: gmo_response['PayTimes'],
      approve: gmo_response['Approve'],
      tran_id: gmo_response['TranID'],
      tran_date: gmo_response['TranDate'],
      check_string: gmo_response['CheckString'],
      amount: current_travel_package.processed_total_price,
      travel_package: current_travel_package,
      access_id: gmo_response['AccessID'],
      access_pass: gmo_response['AccessPass'],
      status: sale_status
    )
  end

  def sale_status
    if current_travel_package.booking_type_campsite_booking?
      campsite_sale_status

    elsif current_travel_package.booking_type_camp_car_booking?
      camp_car_sale_status
    elsif current_travel_package.booking_type_tour_booking?

    end
  end

  # example of requirement
  # today is: 1 Jan
  # if booking is created on 1st Jan, 2nd Jan, 3rd Jan then it will be actual sale
  def campsite_sale_status
    campsite_booking = current_travel_package.campsite_booking

    if campsite_booking.check_in < NUMBER_OF_DAY_FOR_ACTUAL_SALE.days.from_now.beginning_of_day
      return ACTUAL_SALE
    elsif campsite_booking.check_in < NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.beginning_of_day
      return TEMPORARY_SALE
    else
      return VALIDATE_CARD
    end
  end

  # example of requirement
  # today is: 1 Jan
  # if booking is created on 1st Jan, 2nd Jan, 3rd Jan then it will be actual sale
  def camp_car_sale_status
    camp_car_booking = current_travel_package.camp_car_booking

    if camp_car_booking.start_date_of_renting < NUMBER_OF_DAY_FOR_ACTUAL_SALE.days.from_now.beginning_of_day
      return ACTUAL_SALE
    elsif camp_car_booking.start_date_of_renting < NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.beginning_of_day
      return TEMPORARY_SALE
    else
      return VALIDATE_CARD
    end
  end

end
