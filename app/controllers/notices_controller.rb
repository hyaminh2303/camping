class NoticesController < ApplicationController

  def index
    @notices = Notice.without_keep_private.with_item_type(params[:item_type]).page(params[:page]).order_publish_date_desc_null_last
    if(params[:campsite_id].present?)
      @notices = @notices.with_notice_itemable_id(params[:campsite_id])
    end
  end

  def show
    @notice = Notice.without_keep_private.find params[:id]
  end

end