class AddSupplierCompanyToCampsiteBookings < ActiveRecord::Migration[6.1]
  def change
    add_reference :campsite_bookings, :supplier_company
  end
end
