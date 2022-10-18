class CampsiteBookingMailer < BookingMailer
  # E09 | https://app.clickup.com/t/1rw63pq
  def send_actual_sale_reminder_email_to_customer(travel_package)
    @travel_package = travel_package
    @customer_name = @travel_package.customer_user&.full_name.presence || @travel_package.booking_contact_information.name
    @customer_last_name = @travel_package.customer_user&.last_name.presence || @travel_package.booking_contact_information.name
    customer_email =  @travel_package.customer_user&.email.presence || @travel_package.booking_contact_information.email

    mail(
      to: customer_email,
      subject: '【G’Camp】 予約確認メール（3日前）'
    )
  end
  # A09 | https://app.clickup.com/t/1rw63pq
  def send_actual_sale_reminder_email_to_admin(travel_package)
    @travel_package = travel_package

    if @travel_package.item.email_address.present?
      mail(
        to: @travel_package.item.email_address,
        subject: '【G’Camp】　（キャンプ場）ご予約受付のお知らせ'
      )
    end
  end

  # E16 | https://app.clickup.com/t/1rw63qk
  def send_actual_sale_email_to_customer(travel_package)
    @travel_package = travel_package
    @customer_name = @travel_package.customer_user&.full_name.presence || @travel_package.booking_contact_information.name
    @customer_last_name = @travel_package.customer_user&.last_name.presence || @travel_package.booking_contact_information.name
    customer_email =  @travel_package.customer_user&.email.presence || @travel_package.booking_contact_information.email

    mail(
      to: customer_email,
      subject: '【G’Camp】　決済承認通知'
    )
  end
  # *** | https://app.clickup.com/t/1rw63qk
  def send_actual_sale_email_to_admin(travel_package)
  end

  # E06 | https://app.clickup.com/t/22q4k7w
  def send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_customer(travel_package)
    @travel_package = travel_package
    @customer_last_name = @travel_package.customer_user&.last_name.presence || @travel_package.booking_contact_information.name
    @customer_full_name = @travel_package.customer_user&.full_name.presence || @travel_package.booking_contact_information.name
    customer_email = @travel_package.customer_user&.email.presence || @travel_package.booking_contact_information.email

    mail(
      to: customer_email,
      subject: '【G’Camp】　キャンプ場　ご予約確認メール'
    )
  end
  # A06 | https://app.clickup.com/t/22q4k7w
  def send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_admin(travel_package)
    @travel_package = travel_package

    if @travel_package.item.email_address.present?
      mail(
        to: @travel_package.item.email_address,
        subject: '【G’Camp】　（キャンプ場）ご予約受付のお知らせ'
      )
    end
  end

  # E06 | https://app.clickup.com/t/1rw63pf
  def send_temporary_sale_email_to_customer(travel_package)
    @travel_package = travel_package
    @customer_last_name = @travel_package.customer_user&.last_name.presence || @travel_package.booking_contact_information.name
    @customer_full_name = @travel_package.customer_user&.full_name.presence || @travel_package.booking_contact_information.name
    customer_email = @travel_package.customer_user&.email.presence || @travel_package.booking_contact_information.email

    mail(
      to: customer_email,
      subject: '【G’Camp】　キャンプ場　ご予約確認メール'
    )
  end
  # A06 | https://app.clickup.com/t/1rw63pf
  def send_temporary_sale_email_to_admin(travel_package)
    @travel_package = travel_package

    if @travel_package.item.email_address.present?
      mail(
        to: @travel_package.item.email_address,
        subject: '【G’Camp】　（キャンプ場）ご予約受付のお知らせ'
      )
    end
  end

  # E12 | https://app.clickup.com/t/1rw63py
  def send_booking_cancellation_confirmation_to_customer(travel_package)
    @travel_package = travel_package
    @customer_name = @travel_package.customer_user&.full_name.presence ||
                     @travel_package.booking_contact_information.name
    customer_email = @travel_package.customer_user&.email.presence ||
                     @travel_package.booking_contact_information.email

    mail(
      to: customer_email,
      subject: '【G’Camp】　キャンプ場　ご予約キャンセル確認メール'
    )
  end
  # A12 | https://app.clickup.com/t/1rw63py
  def send_booking_cancellation_confirmation_to_admin(travel_package)
    @travel_package = travel_package

    if @travel_package.item.email_address.present?
      mail(
        to: @travel_package.item.email_address,
        subject: '【G’Camp】　（キャンプ場）キャンセル受付のお知らせ',
        cc: Settings.cc_email
      )
    end
  end

  def send_temporary_sale_email_without_credit_card_to_customer(customer_user)
    @customer_user = customer_user

    mail(
      to: @customer_user.email,
      subject: 'Temporary booking confirmation without credit card'
    )
  end

  def send_credit_card_detail_url_email(travel_package)
    @travel_package = travel_package

    mail(
      to: @travel_package.customer_user.email,
      subject: 'Add the credit card to the confirmation booking'
    )
  end
end