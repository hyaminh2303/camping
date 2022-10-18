class AddSupplierCompanyIdToChildAndPetSettings < ActiveRecord::Migration[6.1]
  def change
    add_reference :child_and_pet_settings, :supplier_company
  end
end
