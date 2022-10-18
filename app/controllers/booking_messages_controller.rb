class BookingMessagesController < ApplicationController

  def create
    @booking_message = BookingMessage.new(booking_message_params)

    message_detail = get_new_booking_message_detail_from(@booking_message)
    message_detail.owner = current_customer_user

    if @booking_message.save
      BookingMessageDetailMailer.send_email_with_message_received_to_customer(message_detail).deliver_now
      BookingMessageDetailMailer.send_email_with_message_received_to_admin(message_detail).deliver_now
    end
  end

  def update
    @booking_message = BookingMessage.find(params[:id])

    @booking_message.assign_attributes(booking_message_params)

    message_detail = get_new_booking_message_detail_from(@booking_message)
    message_detail.owner = current_customer_user

    if @booking_message.save
      BookingMessageDetailMailer.send_email_with_message_received_to_customer(message_detail).deliver_now
      BookingMessageDetailMailer.send_email_with_message_received_to_admin(message_detail).deliver_now
    end
  end

  def show
    @booking_message = BookingMessage.find(params[:id])

    render layout: false
  end

  private

  def booking_message_params
    params.require(:booking_message).permit(
      :customer_user_id,
      :subject,
      :booking_messageable_gid,
      booking_message_details_attributes: [:id, :booking_message_id, :owner_type, :owner_id, :message]
    )
  end

  def get_new_booking_message_detail_from(booking_message)
    # Only get one by one when create message
    booking_message.booking_message_details.select{|x| x.new_record?}.first
  end
end
