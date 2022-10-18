class RemoveSupplierCompanyIdFromChildAndPetSettings < ActiveRecord::Migration[6.1]
  def change
    remove_reference :child_and_pet_settings, :supplier_company
  end
end
