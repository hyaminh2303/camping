class RemovePostCodePrefixPostCodeSuffixFromBookingContactInformations < ActiveRecord::Migration[6.1]
  def change
    remove_column :booking_contact_informations, :post_code_prefix, :string
    remove_column :booking_contact_informations, :post_code_suffix, :string
  end
end
