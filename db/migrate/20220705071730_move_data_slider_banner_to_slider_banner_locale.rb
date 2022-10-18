class MoveDataSliderBannerToSliderBannerLocale < ActiveRecord::Migration[6.1]
  def change
    photos_group_by_photoable_id = Photo.where(photoable_type: 'SliderBanner').group_by(&:photoable_id)

    photos_group_by_photoable_id.each do |photoable_id, photos|
      slider_banner = SliderBanner.find_by_id(photoable_id)

      if slider_banner.present?
        photos.each do |photo|
          photo.photoable_id = nil
          photo.photoable_type = nil
        end
        slider_banner_locale = slider_banner.slider_banner_locales.build(locale: "ja")
        slider_banner_locale.photos = photos
        slider_banner_locale.save!
      end
    end
  end
end
