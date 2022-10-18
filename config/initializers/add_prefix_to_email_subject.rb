class AddPrefixToEmailSubject
  COMPANY_NAME = 'MyApp'

  def self.delivering_email(mail)
    mail.subject.prepend(email_prefix)
  end

  def self.email_prefix
    prefixes = []
    if Rails.env.production?
      ''
    else
      prefixes << Rails.env.upcase
      "[#{prefixes.join(' ')}] "
    end
  end
end

ActionMailer::Base.register_interceptor(AddPrefixToEmailSubject)
