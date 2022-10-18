require 'rails_helper'

RSpec.describe CampsiteBookingPriceCalculationService, type: :service do
  before(:each) do
    @child_and_pet_setting_1 = create(:child_and_pet_setting)
    @child_and_pet_setting_2 = create(:child_and_pet_setting)
    @child_and_pet_setting_3 = create(:child_and_pet_setting)
    @child_and_pet_setting_4 = create(:child_and_pet_setting)
    @child_and_pet_setting_5 = create(:child_and_pet_setting)
    @child_and_pet_setting_6 = create(:child_and_pet_setting)

    @campsite_plan = create(:campsite_plan)
    @campsite = @campsite_plan.campsite

    campsite_entrance_fee = create(:campsite_entrance_fee, adult_fee: 800, campsite: @campsite)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_1, campsite_entrance_fee: campsite_entrance_fee, fee_value: 700)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_2, campsite_entrance_fee: campsite_entrance_fee, fee_value: 600)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_3, campsite_entrance_fee: campsite_entrance_fee, fee_value: 500)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_4, campsite_entrance_fee: campsite_entrance_fee, fee_value: 400)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_5, campsite_entrance_fee: campsite_entrance_fee, fee_value: 0)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_6, campsite_entrance_fee: campsite_entrance_fee, fee_value: 500)

    campsite_plan_fee = create(:campsite_plan_fee,
      campsite_plan: @campsite_plan,
      fee_type: :normal
    )

    campsite_plan_fee.create_normal_campsite_plan_fee_detail(
      basic_fee: 50000,
      number_of_people_pet_included: 4,
      extra_person_fee: 35000,
      normal_campsite_plan_fee: campsite_plan_fee
    )
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 30000,
      child_and_pet_setting: @child_and_pet_setting_1)
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 20000,
      child_and_pet_setting: @child_and_pet_setting_2)
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 10000,
      child_and_pet_setting: @child_and_pet_setting_3)
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 8000,
      child_and_pet_setting: @child_and_pet_setting_4)
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 1000,
      child_and_pet_setting: @child_and_pet_setting_5)
    campsite_plan_fee.normal_child_and_pet_fees.create(fee_value: 1000,
      child_and_pet_setting: @child_and_pet_setting_6)
  end

  describe "normal campsite plan fee - Plan D" do
    it "calculates price when 2 Adults + 1 (a)Child" do
      travel_package = TravelPackage.new(
        status: :incomplete
      )
      campsite_booking = CampsiteBooking.new(
        campsite_plan: @campsite_plan,
        travel_package: travel_package,
        check_in: Time.current,
        check_out: Time.current + 1.day,
        number_of_adult: 2
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_1,
        entity_label: @child_and_pet_setting_1.entity_label,
        entity_type: @child_and_pet_setting_1.entity_type,
        quantity: 1
      )

      service = CampsiteBookingPriceCalculationService.new(campsite_booking)
      price = service.calculate
      expect(price).to eq(52300)
    end

    it "calculates price when 1 Adults + 1 (b) Child + 1 (c)Child" do
      travel_package = TravelPackage.new(
        status: :incomplete
      )
      campsite_booking = CampsiteBooking.new(
        campsite_plan: @campsite_plan,
        travel_package: travel_package,
        check_in: Time.current,
        check_out: Time.current + 1.day,
        number_of_adult: 1
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_2,
        entity_label: @child_and_pet_setting_2.entity_label,
        entity_type: @child_and_pet_setting_2.entity_type,
        quantity: 1
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_3,
        entity_label: @child_and_pet_setting_3.entity_label,
        entity_type: @child_and_pet_setting_3.entity_type,
        quantity: 1
      )

      service = CampsiteBookingPriceCalculationService.new(campsite_booking)
      price = service.calculate
      expect(price).to eq(51900)
    end

    it "calculates price when 1 Adult + 2 (a)Child + 1(d)Child + 1 (e) Child" do
      travel_package = TravelPackage.new(
        status: :incomplete
      )
      campsite_booking = CampsiteBooking.new(
        campsite_plan: @campsite_plan,
        travel_package: travel_package,
        check_in: Time.current,
        check_out: Time.current + 1.day,
        number_of_adult: 1
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_1,
        entity_label: @child_and_pet_setting_1.entity_label,
        entity_type: @child_and_pet_setting_1.entity_type,
        quantity: 2
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_4,
        entity_label: @child_and_pet_setting_4.entity_label,
        entity_type: @child_and_pet_setting_4.entity_type,
        quantity: 1
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_5,
        entity_label: @child_and_pet_setting_5.entity_label,
        entity_type: @child_and_pet_setting_5.entity_type,
        quantity: 1
      )

      service = CampsiteBookingPriceCalculationService.new(campsite_booking)
      price = service.calculate
      expect(price).to eq(53600)
    end

    it "calculates price when 1 Adults + 1 Pet" do
      travel_package = TravelPackage.new(
        status: :incomplete
      )
      campsite_booking = CampsiteBooking.new(
        campsite_plan: @campsite_plan,
        travel_package: travel_package,
        check_in: Time.current,
        check_out: Time.current + 1.day,
        number_of_adult: 1
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_6,
        entity_label: @child_and_pet_setting_6.entity_label,
        entity_type: @child_and_pet_setting_6.entity_type,
        quantity: 1
      )

      service = CampsiteBookingPriceCalculationService.new(campsite_booking)
      price = service.calculate
      expect(price).to eq(51300)
    end

    it "calculates price when 5 Adults + 2(c)Child + 2(e)Child" do
      travel_package = TravelPackage.new(
        status: :incomplete
      )
      campsite_booking = CampsiteBooking.new(
        campsite_plan: @campsite_plan,
        travel_package: travel_package,
        check_in: Time.current,
        check_out: Time.current + 1.day,
        number_of_adult: 5
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_3,
        entity_label: @child_and_pet_setting_3.entity_label,
        entity_type: @child_and_pet_setting_3.entity_type,
        quantity: 2
      )

      campsite_booking.child_and_pet_included_in_bookings.build(
        child_and_pet_setting: @child_and_pet_setting_5,
        entity_label: @child_and_pet_setting_5.entity_label,
        entity_type: @child_and_pet_setting_5.entity_type,
        quantity: 2
      )

      service = CampsiteBookingPriceCalculationService.new(campsite_booking)
      price = service.calculate
      expect(price).to eq(112000)
    end

  end
end
