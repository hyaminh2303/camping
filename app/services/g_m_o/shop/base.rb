module GMO
  module Shop
    class Base
      attr_accessor :gmo_shop
      def initialize
        @gmo_shop = GMO::Payment::ShopAPI.new(
          :shop_id => Rails.application.credentials[:shop_id],
          :shop_pass => Rails.application.credentials[:shop_pass],
          :host => Rails.application.credentials[:gmo_host]
        )
      end
    end
  end
end
