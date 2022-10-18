class UpdatePublishDateForExistingNotices < ActiveRecord::Migration[6.1]
  def change
    [4,5,7].each do |notice_id|
      notice = Notice.find_by(id: notice_id)

      next if notice.blank?

      notice.update(publish_date: '07/07/2022'.to_date)
      puts '.'
    end
  end
end
