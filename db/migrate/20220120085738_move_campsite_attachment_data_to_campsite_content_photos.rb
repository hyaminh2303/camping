class MoveCampsiteAttachmentDataToCampsiteContentPhotos < ActiveRecord::Migration[6.1]
  def change
    Campsite.all.each do |c|
      next if c.attachment.blank?

      c.campsite_content_photos.create!(
        photo_attributes: {
          image: c.attachment
        }
      )
    end
  end
end
