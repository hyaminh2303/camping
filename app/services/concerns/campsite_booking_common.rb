module CampsiteBookingCommon
  extend ActiveSupport::Concern

  private

  def clean_up_old_incomplete_travel_package
    customer_user.travel_packages.with_status(:incomplete).with_booking_type(:campsite_booking).destroy_all
  end

  def set_children_and_pets
    campsite_plan.campsite.child_and_pet_settings.order(entity_type: :asc).each do |child_and_pet_setting|
      attrs = {
        child_and_pet_setting: child_and_pet_setting,
        entity_type: child_and_pet_setting.entity_type,
        quantity: 0
      }

      I18n.available_locales.each do |locale|
        attrs["entity_label_#{locale}"] = child_and_pet_setting.send("entity_label_#{locale}")
      end

      @travel_package.campsite_booking.child_and_pet_included_in_bookings.build(attrs)
    end
  end

  def set_campsite_booking_options
    campsite_booking = @travel_package.campsite_booking
    campsite_booking.campsite_plan.campsite_plan_options.each do |campsite_plan_option|
      attrs = {
        campsite_plan_option: campsite_plan_option,
        price: campsite_plan_option.price
      }

      I18n.available_locales.each do |locale|
        attrs["name_#{locale}"] = campsite_plan_option.send("name_#{locale}")
      end

      campsite_booking.campsite_options_included_in_booking.build(attrs)
    end
  end

  def campsite_price_calculation_service
    campsite_booking = @travel_package.campsite_booking
    campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

    CampsiteBookingPriceCalculationService.new(
      campsite_booking,
      with_entrance_fee: !campsite_plan_is_included_entrance_fee
    )
  end

  def set_travel_package_payment_method
    payment_method =
      if campsite_supplier_company.contract_type_commission_base?
        :credit_card
      elsif campsite_supplier_company.contract_type_no_commission?
        :cash
      end

    @travel_package.payment_method = payment_method
  end

  def campsite_supplier_company
    @travel_package.campsite_booking.campsite_plan.campsite.campsite_supplier_company
  end

end