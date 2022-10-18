class AddSupplierCompanyToCampCarBookings < ActiveRecord::Migration[6.1]
  def change
    add_reference :camp_car_bookings, :supplier_company
  end
end
