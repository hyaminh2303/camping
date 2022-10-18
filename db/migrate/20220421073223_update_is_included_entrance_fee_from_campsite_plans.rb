class UpdateIsIncludedEntranceFeeFromCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    CampsitePlan.all.each do |c|
      c.update_column(:is_included_entrance_fee, true)
    end
  end
end
