class CampsiteBookingService
  include CampsiteBookingCommon

  attr_reader :booking_params, :customer_user, :travel_package, :campsite_plan, :travel_package_of_campsite_booking_draft

  def initialize(customer_user, params, travel_package_of_campsite_booking_draft: {})
    @booking_params = params
    @customer_user = customer_user
    @campsite_plan = CampsitePlan.find_by(id: params[:id])
    @travel_package_of_campsite_booking_draft = travel_package_of_campsite_booking_draft
  end

  def init_travel_package
    check_in_time = campsite_booking_draft['check_in']&.to_date || Date.current + 1.day
    check_out_time = campsite_booking_draft['check_out']&.to_date || Date.current + 2.days
    number_of_adult = if campsite_booking_draft['number_of_adult'].present?
      campsite_booking_draft['number_of_adult'].to_i
    else
      1
    end

    @travel_package = customer_user.travel_packages.build(
      status: :incomplete,
      booking_type: :campsite_booking,
      campsite_booking_attributes: {
        campsite_plan: campsite_plan,
        check_in: check_in_time,
        check_out: check_out_time,
        number_of_adult: number_of_adult
      }
    )

    set_children_and_pets
    set_quantity_of_children_and_pets_by_draft
    set_travel_package_payment_method
    @travel_package.total_price = campsite_price_calculation_service.calculate
    @travel_package
  end

  def create_travel_package
    customer_user.clean_up_old_incomplete_travel_package_of_campsite_booking
    @travel_package = customer_user.travel_packages.build(booking_params)
    set_campsite_booking_options
    set_travel_package_payment_method
    @travel_package.total_price = campsite_price_calculation_service.calculate
    @travel_package.save
    @travel_package
  end

  private

  def campsite_booking_draft
    @campsite_booking_draft ||= travel_package_of_campsite_booking_draft.try(:[], 'campsite_booking') || {}
  end

  def children_and_pets_draft
    @children_and_pets_draft ||= campsite_booking_draft['child_and_pet_included_in_bookings'] || []
  end

  def set_quantity_of_children_and_pets_by_draft
    if children_and_pets_draft.present?
      child_and_pet_included_in_bookings = @travel_package.campsite_booking.child_and_pet_included_in_bookings

      child_and_pet_included_in_bookings.each do |child_and_pet_included_in_booking|
        child_and_pet_draft = children_and_pets_draft.select do |children_and_pet_draft|
          children_and_pet_draft['child_and_pet_setting_id'] == child_and_pet_included_in_booking.child_and_pet_setting_id
        end.first || {}

        quantity = child_and_pet_draft['quantity']
        child_and_pet_included_in_booking.quantity = quantity.to_i if quantity.present?
      end
    end
  end
end
