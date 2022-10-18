Devise.module_eval do
  class << self
    alias_method :origin_mailer, :mailer
  end

  def self.mailer
    origin_mailer.class_eval do
      before_action :add_inline_attachments!

      def add_inline_attachments!
        attachments.inline['logo-email.png'] = File.read(Rails.root.join('app/assets/images/logo-email.png'))
      end
    end

    origin_mailer
  end
end
