class UpdateTimezoneForCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    CampsitePlan.all.each do |c|
      c.check_in_time -= 9.hour
      c.check_out_time -= 9.hour
      c.save
    end
  end
end
