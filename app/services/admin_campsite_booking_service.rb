class AdminCampsiteBookingService
  include CampsiteBookingCommon

  attr_reader :booking_params, :customer_user, :travel_package, :campsite_plan

  def initialize(params, customer_user=nil)
    @booking_params = params
    @customer_user = customer_user
    @campsite_plan = CampsitePlan.find_by(id: params[:campsite_plan_id])
  end

  def init_travel_package
    @travel_package = if customer_user.present?
      customer_user.travel_packages.build(params_travel_package.merge(booking_contract_information_attributes_with(customer_user)))
    else
      TravelPackage.new(params_travel_package)
    end

    set_children_and_pets
    set_campsite_booking_options
    set_travel_package_payment_method
    @travel_package.total_price = campsite_price_calculation_service.calculate
    @travel_package
  end

  def params_travel_package
    {
      status: :incomplete,
      booking_type: :campsite_booking,
      is_booking_outside: true,
      campsite_booking_attributes: {
        campsite_plan: campsite_plan,
        check_in: Date.current + 1.day,
        check_out: Date.current + 2.days,
        number_of_adult: 1
      }
    }
  end

  def booking_contract_information_attributes_with(customer_user)
    {
      booking_contact_information_attributes: {
        email: customer_user.email,
        name: customer_user.full_name,
        post_code: customer_user.post_code,
        address: customer_user.address,
        birthday: customer_user.birthday,
        phone_number: customer_user.phone_number
      }
    }
  end

end