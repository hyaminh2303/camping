class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: Settings.mailer_sender
  layout 'mailer'

  before_action :add_inline_attachments!

  private

  def add_inline_attachments!
    mailer_actions_without_logo = [
      'send_temporary_sale_email_without_credit_card_to_customer',
      'send_credit_card_detail_url_email'
    ]

    # https://app.clickup.com/t/2c6940u
    return if mailer_actions_without_logo.include?(action_name)

    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/logo.png'))
    attachments.inline['logo-email.png'] = File.read(Rails.root.join('app/assets/images/logo-email.png'))
  end
end
