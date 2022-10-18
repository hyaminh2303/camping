module NoticeHelper
  def pre_notice(notice)
    notice_ids = Notice.without_keep_private.with_item_type(notice.item_type).order_publish_date_desc_null_last.pluck(:id)
    pre_notice_index =
      if notice_ids.first == params[:id].to_i
        notice_ids.index(notice_ids.last)
      else
        notice_ids.index(params[:id].to_i).pred
      end
    pre_notice_id = notice_ids[pre_notice_index]
  end

  def next_notice(notice)
    notice_ids = Notice.without_keep_private.with_item_type(notice.item_type).order_publish_date_desc_null_last.pluck(:id)

    next_notice_index =
      if notice_ids.last == params[:id].to_i
        0
      else
        notice_ids.index(params[:id].to_i).next
      end

    next_notice_id = notice_ids[next_notice_index]
  end

end
