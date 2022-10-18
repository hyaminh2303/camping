class MemberRegistrationMailer < ApplicationMailer
  def send_verification_email_to_customer(params)
    @params = params

    mail(
      to: @params[:email],
      subject: '【G’Camp】　仮登録完了のお知らせ'
    )
  end

end