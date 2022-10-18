class BookingMessageDetailMailer < ApplicationMailer
  # E04 | https://app.clickup.com/t/1rw63p4
  def send_email_with_message_received_to_customer(booking_message_detail)
    @booking_message_detail = booking_message_detail

    mail(
      to: @booking_message_detail.owner.email,
      subject: '【G’Camp】　メッセージをお預かりしました'
    )
  end
  # A04 | https://app.clickup.com/t/1rw63p4
  def send_email_with_message_received_to_admin(booking_message_detail)
    @booking_message_detail = booking_message_detail

    @item = @booking_message_detail.booking_message.booking_messageable.item

    if @item.email_address.present?
      mail(
        to: @item.email_address,
        subject: '【G’Camp】　メッセージ受信のお知らせ'
      )
    end
  end
end
