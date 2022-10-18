if !Rails.env.production?
  namespace :convert_prod_db_to_test do
    task update_campsite_email_address: :environment do
      # Avoid sending to the customer email when booking
      Campsite.all.each do |c|
        next if c.email_address.blank?

        c.update_column(:email_address, 'minh.hy@sazae.com.au, member.webm@gmail.com')
        print '.'
      end
    end
  end
end