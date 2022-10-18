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
    @campsite.update(
      basic_fee: 30000,
      extra_person_fee: 0,
      number_of_people_pet_included: 0
    )

    campsite_entrance_fee = create(:campsite_entrance_fee, adult_fee: 800, campsite: @campsite)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_1, campsite_entrance_fee: campsite_entrance_fee, fee_value: 700)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_2, campsite_entrance_fee: campsite_entrance_fee, fee_value: 600)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_3, campsite_entrance_fee: campsite_entrance_fee, fee_value: 500)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_4, campsite_entrance_fee: campsite_entrance_fee, fee_value: 400)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_5, campsite_entrance_fee: campsite_entrance_fee, fee_value: 0)

    create(:child_and_pet_entrance_fee, child_and_pet_setting: @child_and_pet_setting_6, campsite_entrance_fee: campsite_entrance_fee, fee_value: 500)

    @campsite_plan_fee = create(:campsite_plan_fee,
      campsite_plan: @campsite_plan,
      fee_type: :classification_day
    )

    @classification_day_setting_weekday = create(:classification_day_setting)
    @classification_day_setting_weekend = create(:classification_day_setting)

    @first_night = "2021-10-01 04:21:48.993968 +0000".to_time
    create(:date_setting, date: @first_night.to_date,
      classification_day_setting: @classification_day_setting_weekday
    )

    create(:date_setting, date: @first_night.to_date + 1.day,
      classification_day_setting: @classification_day_setting_weekend
    )

    @campsite_plan_fee.classification_day_settings << @classification_day_setting_weekday << @classification_day_setting_weekend

    @campsite_plan_fee.classification_day_campsite_plan_fee_details.create(
      basic_fee: 10000,
      extra_person_fee: 0,
      number_of_people_pet_included: 0,
      classification_day_setting: @classification_day_setting_weekday
    )

    @campsite_plan_fee.classification_day_campsite_plan_fee_details.create(
      basic_fee: 20000,
      extra_person_fee: 0,
      number_of_people_pet_included: 0,
      classification_day_setting: @classification_day_setting_weekend
    )

    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8009,
      child_and_pet_setting: @child_and_pet_setting_1,
      classification_day_setting: @classification_day_setting_weekday
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8008,
      child_and_pet_setting: @child_and_pet_setting_2,
      classification_day_setting: @classification_day_setting_weekday
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8007,
      child_and_pet_setting: @child_and_pet_setting_3,
      classification_day_setting: @classification_day_setting_weekday
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8006,
      child_and_pet_setting: @child_and_pet_setting_4,
      classification_day_setting: @classification_day_setting_weekday
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8005,
      child_and_pet_setting: @child_and_pet_setting_5,
      classification_day_setting: @classification_day_setting_weekday
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 8004,
      child_and_pet_setting: @child_and_pet_setting_6,
      classification_day_setting: @classification_day_setting_weekday
    )


    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9009,
      child_and_pet_setting: @child_and_pet_setting_1,
      classification_day_setting: @classification_day_setting_weekend
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9008,
      child_and_pet_setting: @child_and_pet_setting_2,
      classification_day_setting: @classification_day_setting_weekend
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9007,
      child_and_pet_setting: @child_and_pet_setting_3,
      classification_day_setting: @classification_day_setting_weekend
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9006,
      child_and_pet_setting: @child_and_pet_setting_4,
      classification_day_setting: @classification_day_setting_weekend
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9005,
      child_and_pet_setting: @child_and_pet_setting_5,
      classification_day_setting: @classification_day_setting_weekend
    )
    @campsite_plan_fee.classification_day_child_and_pet_fees.create(fee_value: 9004,
      child_and_pet_setting: @child_and_pet_setting_6,
      classification_day_setting: @classification_day_setting_weekend
    )
  end

  describe "normal campsite plan fee - Plan B" do
    context "checks to both checkbox weekday and weekend" do
      # total entrance for 2 nights = (800*2+700)*2 = 4600
      # weekday(t6) = 10000*2+8009 = 28009
      # weekend(t7) = 20000*2+9009 = 49009
      # total = 4600+28009+49009 = 81618
      it "calculates price when 2 Adults + 1 (a)Child" do
        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.days,
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
        expect(price).to eq(81618)
      end

      # total entrance for 2 nights = (800+600+500)*2 = 3800
      # weekday(t6) = 10000+8008+8007 = 26015
      # weekend(t7) = 20000+9008+9007 = 38015
      # total = 3800+26015+38015 = 67830
      it "calculates price when 1 Adults + 1 (b) Child + 1 (c)Child" do
        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(67830)
      end

      # total entrance for 2 nights = (800+700*2+400+0)*2 = 5200
      # weekday(t6) = 10000+8009*2+8006+8005 = 42029
      # weekend(t7) = 20000+9009*2+9006+9005 = 56029
      # total = 5200+42029+56029 = 103258
      it "calculates price when 1 Adult + 2 (a)Child + 1(d)Child + 1 (e) Child" do
        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(103258)
      end

      # total entrance for 2 nights = (800+500)*2 = 2600
      # weekday(t6) = 10000+8004 = 18004
      # weekend(t7) = 20000+9004 = 29004
      # total = 2600+18004+29004 = 49608
      it "calculates price when 1 Adult + 1 Pet" do
        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(49608)
      end

      # total entrance for 2 nights = (800*5+500*2+0*2)*2 = 10000
      # weekday(t6) = 10000*5+8007*2+8005*2 = 82024
      # weekend(t7) = 20000*5+9007*2+9005*2 = 136024
      # total = 10000+82024+136024 = 228048
      it "calculates price when 5 Adults + 2(c)Child + 2(e)Child" do
        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(228048)
      end
    end

    context "only checked to checkbox classification_day_setting_weekday" do
      # total entrance for 2 nights = (800*2+700)*2 = 4600
      # weekday(t6) = 10000*2+8009 = 28009
      # weekend(t7) = 30000*2+0 = 60000
      # total = 4600+28009+60000 = 92609
      it "calculates price when 2 Adults + 1 (a)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.days,
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
        expect(price).to eq(92609)
      end

      # total entrance for 2 nights = (800+600+500)*2 = 3800
      # weekday(t6) = 10000+8008+8007 = 26015
      # weekend(t7) = 30000+0+0 = 30000
      # total = 3800+26015+30000 = 59815
      it "calculates price when 1 Adults + 1 (b) Child + 1 (c)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(59815)
      end

      # total entrance for 2 nights = (800+700*2+400+0)*2 = 5200
      # weekday(t6) = 10000+8009*2+8006+8005 = 42029
      # weekend(t7) = 30000+0*2+0+0 = 30000
      # total = 5200+42029+30000 = 77229
      it "calculates price when 1 Adult + 2 (a)Child + 1(d)Child + 1 (e) Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(77229)
      end

      # total entrance for 2 nights = (800+500)*2 = 2600
      # weekday(t6) = 10000+8004 = 18004
      # weekend(t7) = 30000+0 = 30000
      # total = 2600+18004+30000 = 50604
      it "calculates price when 1 Adult + 1 Pet" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(50604)
      end

      # total entrance for 2 nights = (800*5+500*2+0*2)*2 = 10000
      # weekday(t6) = 10000*5+8007*2+8005*2 = 82024
      # weekend(t7) = 30000*5+0*2+0*2 = 150000
      # total = 10000+82024+150000 = 242024
      it "calculates price when 5 Adults + 2(c)Child + 2(e)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(242024)
      end
    end

    context "only checked to checkbox classification_day_setting_weekend" do
      # total entrance for 2 nights = (800*2+700)*2 = 4600
      # weekday(t6) = 30000*2+0 = 60000
      # weekend(t7) = 20000*2+9009 = 49009
      # total = 4600+60000+49009 = 113609
      it "calculates price when 2 Adults + 1 (a)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.days,
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
        expect(price).to eq(113609)
      end

      # total entrance for 2 nights = (800+600+500)*2 = 3800
      # weekday(t6) = 30000+0+0 = 30000
      # weekend(t7) = 20000+9008+9007 = 38015
      # total = 3800+30000+38015 = 71815
      it "calculates price when 1 Adults + 1 (b) Child + 1 (c)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(71815)
      end

      # total entrance for 2 nights = (800+700*2+400+0)*2 = 5200
      # weekday(t6) = 30000+0*2+0+0 = 30000
      # weekend(t7) = 20000+9009*2+9006+9005 = 56029
      # total = 5200+30000+56029 = 91229
      it "calculates price when 1 Adult + 2 (a)Child + 1(d)Child + 1 (e) Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(91229)
      end

      # total entrance for 2 nights = (800+500)*2 = 2600
      # weekday(t6) = 30000+0 = 30000
      # weekend(t7) = 20000+9004 = 29004
      # total = 2600+30000+29004 = 61604
      it "calculates price when 1 Adult + 1 Pet" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(61604)
      end

      # total entrance for 2 nights = (800*5+500*2+0*2)*2 = 10000
      # weekday(t6) = 30000*5+0*2+0*2 = 150000
      # weekend(t7) = 20000*5+9007*2+9005*2 = 136024
      # total = 10000+150000+136024 = 296024
      it "calculates price when 5 Adults + 2(c)Child + 2(e)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(296024)
      end
    end

    context "unchecks to both checkbox weekday and weekend" do
      # total entrance for 2 nights = (800*2+700)*2 = 4600
      # weekday(t6) = 30000*2+0 = 60000
      # weekend(t7) = 30000*2+0 = 60000
      # total = 4600+60000+60000 = 124600
      it "calculates price when 2 Adults + 1 (a)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.days,
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
        expect(price).to eq(124600)
      end

      # total entrance for 2 nights = (800+600+500)*2 = 3800
      # weekday(t6) = 30000+0+0 = 30000
      # weekend(t7) = 30000+0+0 = 30000
      # total = 3800+30000+30000 = 63800
      it "calculates price when 1 Adults + 1 (b) Child + 1 (c)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(63800)
      end

      # total entrance for 2 nights = (800+700*2+400+0)*2 = 5200
      # weekday(t6) = 30000+0*2+0+0 = 30000
      # weekend(t7) = 30000+0*2+0+0 = 30000
      # total = 5200+30000+30000 = 65200
      it "calculates price when 1 Adult + 2 (a)Child + 1(d)Child + 1 (e) Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(65200)
      end

      # total entrance for 2 nights = (800+500)*2 = 2600
      # weekday(t6) = 30000+0 = 30000
      # weekend(t7) = 30000+0 = 30000
      # total = 2600+30000+30000 = 62600
      it "calculates price when 1 Adult + 1 Pet" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(62600)
      end

      # total entrance for 2 nights = (800*5+500*2+0*2)*2 = 10000
      # weekday(t6) = 30000*5+0*2+0*2 = 150000
      # weekend(t7) = 30000*5+0*2+0*2 = 150000
      # total = 10000+150000+150000 = 310000
      it "calculates price when 5 Adults + 2(c)Child + 2(e)Child" do
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekday)
        @campsite_plan_fee.classification_day_settings.destroy(@classification_day_setting_weekend)

        travel_package = TravelPackage.new(
          status: :incomplete
        )
        campsite_booking = CampsiteBooking.new(
          campsite_plan: @campsite_plan,
          travel_package: travel_package,
          check_in: @first_night,
          check_out: @first_night + 2.day,
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
        expect(price).to eq(310000)
      end
    end
  end
end
