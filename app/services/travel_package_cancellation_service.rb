class TravelPackageCancellationService
  attr_reader :travel_package, :gmo_shop, :canceled_by
  attr_accessor :message

  def initialize(travel_package, canceled_by: nil)
    @travel_package = travel_package
    @canceled_by = canceled_by

    @gmo_shop = GMO::Payment::ShopAPI.new(
      :shop_id => "tshop00052178",
      :shop_pass => "qy6prkh7",
      :host => "kt01.mul-pay.jp"
    )
  end

  def run
    if travel_package.is_cancelable?
      cancel_on_gmo
      @travel_package.update(
        status: :canceled,
        canceled_at: Time.current,
        canceled_by: canceled_by
      )

      travel_package.mailer.send_booking_cancellation_confirmation_to_customer(travel_package).deliver_now
      travel_package.mailer.send_booking_cancellation_confirmation_to_admin(travel_package).deliver_now

      self.message = I18n.t("admin.travel_package.cancel_booking_success")
      @success = true
    else
      self.message = I18n.t("admin.travel_package.cancel_booking_error")
      @success = false
    end
  end

  def is_cancel_success?
    @success
  end

  private

  def cancel_on_gmo
    gmo_transaction = travel_package.gmo_transaction
    return if gmo_transaction.blank?

    begin
      gmo_shop.alter_tran(
        order_id: gmo_transaction.order_id,
        access_id: gmo_transaction.access_id,
        access_pass: gmo_transaction.access_pass,
        job_cd: "VOID"
      )
    rescue => e
      Rails.logger.debug(e.message)
    end
  end
end