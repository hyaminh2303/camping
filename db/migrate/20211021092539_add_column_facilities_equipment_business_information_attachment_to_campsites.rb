class AddColumnFacilitiesEquipmentBusinessInformationAttachmentToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :facilities_equipment, :text
    add_column :campsites, :business_information, :text
    add_column :campsites, :attachment, :string
  end
end
