module HomeHelper
  def notice_itemable_path(notice)
    if notice.item_type.campsite?
      campsite_path(notice.notice_itemable)
    elsif notice.item_type.camp_car?
      camp_car_path(notice.notice_itemable)
    else
      # TODO: tour_path
    end
  end
end
