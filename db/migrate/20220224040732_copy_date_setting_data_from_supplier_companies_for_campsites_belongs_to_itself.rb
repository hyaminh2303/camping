class CopyDateSettingDataFromSupplierCompaniesForCampsitesBelongsToItself < ActiveRecord::Migration[6.1]
  def change
    # https://app.clickup.com/t/1qu0tac
    CampsiteSupplierCompany.all.each do |supplier|
      supplier.campsites.each do |campsite|
        DateSetting.where(supplier_company_id: supplier.id).each do |date_setting|
          date_setting_dup = date_setting.dup
          date_setting_dup.campsite_id = campsite.id
          date_setting_dup.save
        end
      end
    end

    DateSetting.where(campsite_id: nil).destroy_all
  end
end
