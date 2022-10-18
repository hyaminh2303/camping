class CreateSliderBannerLocales < ActiveRecord::Migration[6.1]
  def change
    create_table :slider_banner_locales do |t|
      t.string :locale
      t.references :slider_banner

      t.timestamps
    end
  end
end
