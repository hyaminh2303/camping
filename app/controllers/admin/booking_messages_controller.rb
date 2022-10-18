class Admin::BookingMessagesController <  Admin::AdminController

  def update
    @booking_message = BookingMessage.find(params[:id])

    @booking_message.assign_attributes(booking_message_params)

    @booking_message.booking_message_details.each do |message_detail|
      message_detail.owner = current_admin_user if message_detail.new_record?
    end

    @booking_message.save
  end

  private

  def booking_message_params
    params.require(:booking_message).permit(
      :id,
      :customer_user_id,
      :subject,
      :booking_messageable_gid,
      booking_message_details_attributes: [:id, :booking_message_id, :owner_type, :owner_id, :message]
    )
  end
end
