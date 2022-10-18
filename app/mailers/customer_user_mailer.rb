class CustomerUserMailer < ApplicationMailer
  # E02 | https://app.clickup.com/t/1rw63mw
  def send_registration_confirmation(customer_user)
    @customer_user = customer_user

    mail(
      to: @customer_user.email,
      subject: '【G’Camp】会員登録完了のご連絡'
    )
  end
  # E01 | https://app.clickup.com/t/1rw63mc
  def send_verification_email_to_customer(customer_user)
    @customer_user = customer_user

    mail(
      to: @customer_user.email,
      subject: '【G’Camp】　仮登録完了のお知らせ'
    )
  end

  # E03(B) | https://app.clickup.com/t/1rw63n2
  def send_password_reset_confirmation(customer_user)
    @customer_user = customer_user

    mail(
      to: @customer_user.email,
      subject: '【G’Camp】　パスワード変更のお知らせ'
    )
  end

  def send_withdrawal_membership_confirmation_email_to_customer(customer_user)
    @customer_user = customer_user

    mail(
      to: @customer_user.email,
      subject: '【G’Camp】　退会が完了しました'
    )
  end
end
