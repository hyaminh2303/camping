class ContactUsMailer < ApplicationMailer
  # A05 | https://app.clickup.com/t/1rw63pb
  def send_customer_inquiry_detail_email_to_admin(contact_us)
    @contact_us = contact_us

    mail(
      to: Settings.super_admin_email,
      subject: '【G’Camp】　問い合わせ受信のお知らせ'
    )
  end
  # E05 | https://app.clickup.com/t/1rw63pb
  def send_contact_us_confirmation_to_customer(contact_us)
    @contact_us = contact_us

    mail(
      to: @contact_us.email,
      subject: '【G’Camp】　お問合せありがとうございます'
    )
  end
end
