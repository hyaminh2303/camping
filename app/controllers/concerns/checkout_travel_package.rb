module CheckoutTravelPackage
  extend ActiveSupport::Concern

  def booking_contact_information_attributes
    [
      :id,
      :email,
      :name,
      :post_code,
      :address,
      :birthday,
      :phone_number,
      :number_of_male,
      :number_of_female
    ]
  end

  def validate_booking_type
    booking_type = params[:booking_type]
    if TravelPackage::booking_type.values.exclude?(booking_type)
      redirect_back(fallback_location: root_path)
    end
  end
end
