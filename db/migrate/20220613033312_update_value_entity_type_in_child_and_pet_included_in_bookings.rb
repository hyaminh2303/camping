class UpdateValueEntityTypeInChildAndPetIncludedInBookings < ActiveRecord::Migration[6.1]
  def change
    #Update Entity Type to Enumerize
    ChildAndPetIncludedInBooking.all.each do |child_and_pet_included_in_booking|
      entity_type = child_and_pet_included_in_booking.child_and_pet_setting.entity_type
      child_and_pet_included_in_booking.update(entity_type: entity_type)
    end

  end
end
