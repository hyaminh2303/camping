class CampsiteBookingPriceCalculationService
  attr_accessor :current_date, :error_messages
  attr_reader :campsite_booking, :with_entrance_fee

  def initialize(campsite_booking, with_entrance_fee: true)
    @error_messages = []
    @campsite_booking = campsite_booking
    @with_entrance_fee = with_entrance_fee
  end

  def calculate
    return 0 if is_invalid_campsite_booking?

    total = if with_entrance_fee
      total_entrance_fee
    else
      0
    end

    (@campsite_booking.check_in.to_date...@campsite_booking.check_out.to_date).each do |date|
      self.current_date = date
      total += total_plan_fee_of_current_date
    end

    total += calculate_campsite_options_included_in_booking_total_fee

    total
  end

  private

  def is_invalid_campsite_booking?
    campsite_booking.valid_attributes?(:number_of_adult)
    error_messages.push(campsite_booking.errors.full_messages_for(:number_of_adult))

    campsite_booking.child_and_pet_included_in_bookings.each do |child_and_pet_included_in_booking|
      child_and_pet_included_in_booking.valid_attributes?(:quantity)
      error_messages.push(child_and_pet_included_in_booking.errors.full_messages_for(:quantity))
    end

    error_messages.flatten!.present?
  end

  def calculate_campsite_options_included_in_booking_total_fee
    total_fee = 0

    campsite_booking.campsite_options_included_in_booking.each do |campsite_option_included_in_booking|
      total_fee += campsite_option_included_in_booking.total_fee
    end

    total_fee
  end

  def total_plan_fee_of_current_date
    return 0 if current_date.blank?

    if number_of_people_and_pet_included.zero?
      total_adult_plan_fee = campsite_booking.number_of_adult.to_i * adult_fee

      # số lượng chỗ miễn phí còn lại dành cho children, theo thảo luận thì children có giá cao hơn sẽ dc miễn phí nếu còn chỗ
      remaining_seat_for_child_can_be_included = 0

    elsif number_of_adult_less_than_number_of_people_and_pet_included?
      total_adult_plan_fee = plan_fee_of_current_date[:basic_fee]
      remaining_seat_for_child_can_be_included =
        number_of_people_and_pet_included - campsite_booking.number_of_adult.to_i

    else
      total_adult_plan_fee =
        (campsite_booking.number_of_adult.to_i / number_of_people_and_pet_included) *
        plan_fee_of_current_date[:basic_fee]

      total_adult_plan_fee +=
        (campsite_booking.number_of_adult.to_i % number_of_people_and_pet_included) *
        plan_fee_of_current_date[:extra_person_fee]

      remaining_seat_for_child_can_be_included = 0
    end

    children_and_pet =
      set_plan_fee_for_each_child_pet_and_then_build_array_of_children_base_on_quantity

    # delete number of children in array base on remaining_seat_for_child_can_be_included
    children_and_pet.shift(remaining_seat_for_child_can_be_included)

    total_children_fee = 0
    children_and_pet.each do |child_and_pet_included|
      total_children_fee += child_and_pet_included.fee
    end

    total_adult_plan_fee + total_children_fee
  end

  def set_plan_fee_for_each_child_pet_and_then_build_array_of_children_base_on_quantity
    campsite_booking.child_and_pet_included_in_bookings.each do |child_and_pet_included|
      child_and_pet_fee = child_and_pet_fee_of(campsite_plan_fee, child_and_pet_included)

      child_and_pet_included.assign_attributes(
        fee: child_and_pet_fee&.fee_value.to_f
      )
    end

    campsite_booking.child_and_pet_included_in_bookings.map do |child_and_pet_included|
      child_and_pet_included.quantity.times.map do
        child_and_pet_included
      end
    end.flatten.sort_by { |c| c.fee }.reverse
  end

  def child_and_pet_fee_of(campsite_plan_fee, child_and_pet_included)
    if campsite_plan_fee.normal?
      campsite_plan_fee.normal_child_and_pet_fees.find_by(
        child_and_pet_setting: child_and_pet_included.child_and_pet_setting
      )
    else
      date_setting = DateSetting.find_by(date: current_date, campsite: campsite)

      # there is no child fee for this day
      return nil if date_setting.blank?

      # if Admin doesnt check on this date in UI. that case, we will use default value of basic fee at campsite
      return nil if campsite_plan_fee.classification_day_setting_ids.exclude?(date_setting.classification_day_setting_id)

      campsite_plan_fee.classification_day_child_and_pet_fees.find_by(
        child_and_pet_setting: child_and_pet_included.child_and_pet_setting,
        classification_day_setting_id: date_setting.classification_day_setting_id
      )
    end
  end

  def total_entrance_fee
    campsite_entrance_fee = campsite.campsite_entrance_fee
    total_adult_fee = campsite_booking.number_of_adult.to_i * campsite_entrance_fee.adult_fee

    total_child_and_pet_entrance_fee = 0
    campsite_booking.child_and_pet_included_in_bookings.each do |child_and_pet_included|
      child_and_pet_fee = campsite_entrance_fee.child_and_pet_entrance_fees.find_by(
        child_and_pet_setting: child_and_pet_included.child_and_pet_setting
      )

      total_child_and_pet_entrance_fee += child_and_pet_included.quantity.to_i * child_and_pet_fee&.fee_value.to_f
    end

    (total_adult_fee + total_child_and_pet_entrance_fee) * campsite_booking.number_of_nights
  end

  def number_of_adult_less_than_number_of_people_and_pet_included?
    campsite_booking.number_of_adult.to_i < number_of_people_and_pet_included
  end

  def number_of_people_and_pet_included
    plan_fee_of_current_date[:number_of_people_pet_included].to_i
  end

  def adult_fee
    fee = if plan_fee_of_current_date[:basic_fee].to_b
            plan_fee_of_current_date[:basic_fee]
          else
            plan_fee_of_current_date[:extra_person_fee]
          end

    fee.to_f
  end

  def plan_fee_of_current_date
    daily_fee_setting = campsite_plan.campsite_plan_daily_fee_settings.find_by(
      date: current_date
    )

    # If admin set price for specific day, then use it
    return {
      number_of_people_pet_included: daily_fee_setting.number_of_people_pet_included,
      basic_fee: daily_fee_setting.basic_fee,
      extra_person_fee: daily_fee_setting.extra_person_fee
    } if daily_fee_setting.present?

    # if normal campsite plan fee, then use normal_campsite_plan_fee_detail
    # else if classification_day campsite plan fee and admin also checked on the checkbox in UI to select this date, then use it
    return {
      number_of_people_pet_included: campsite_plan_fee_detail.number_of_people_pet_included,
      basic_fee: campsite_plan_fee_detail.basic_fee,
      extra_person_fee: campsite_plan_fee_detail.extra_person_fee
    } if campsite_plan_fee_detail.present?


    return {
      number_of_people_pet_included: campsite.number_of_people_pet_included,
      basic_fee: campsite.basic_fee,
      extra_person_fee: campsite.extra_person_fee
    }
  end

  def campsite_plan_fee_detail
    return campsite_plan_fee.normal_campsite_plan_fee_detail if campsite_plan_fee.normal?
    date_setting = DateSetting.find_by(date: current_date, campsite: campsite)
    return nil if date_setting.blank?

    # if Admin doesnt check on this date in UI. that case, we will use default value of basic fee at campsite
    return nil if campsite_plan_fee.classification_day_setting_ids.exclude?(date_setting.classification_day_setting_id)

    campsite_plan_fee.classification_day_campsite_plan_fee_details.find_by(
      classification_day_setting_id: date_setting.classification_day_setting_id
    )
  end

  def campsite_plan_fee
    @campsite_plan_fee ||= campsite_booking.campsite_plan.campsite_plan_fee
  end

  def campsite
    @campsite ||= campsite_plan.campsite
  end

  def campsite_plan
    @campsite_plan ||= campsite_booking.campsite_plan
  end
end
