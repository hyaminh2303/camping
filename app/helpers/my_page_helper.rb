module MyPageHelper
  def get_booking_info(travel_package)
    if travel_package.booking_type.campsite_booking?

      campsite_booking = travel_package.campsite_booking
      booking_type = campsite_booking.campsite_plan.campsite
      start_date = campsite_booking.check_in.to_date
      end_date = campsite_booking.check_out.to_date

    elsif travel_package.booking_type.camp_car_booking?

      camp_car_booking = travel_package.camp_car_booking
      booking_type = camp_car_booking.camp_car
      start_date = camp_car_booking.start_date_of_renting
      end_date = camp_car_booking.end_date_of_renting

    end

    {
      name: booking_type.name,
      image: booking_type.photos.first&.image,
      start_date: start_date,
      end_date: end_date
    }
  end

end