# GMO::Shop::Transaction.new
module GMO
  module Shop
    class Transaction < Base
      PAY_TIMES = 1 #Payment Installments
      attr_reader :amount, :order_id, :credit_card_instance, :processing_type, :customer_user,
                  :credit_cards_attributes, :travel_package

      # UNPROCESSED:Unprocessed
      # AUTHENTICATED: Unprocessed

      # (3DRegistration Complete)

      # CHECK:Validity Check
      # CAPTURE:Instant Sales
      # AUTH:Provisional Sales
      # SALES:Sales Capture
      # VOID:Cancel
      # RETURN:Return
      # RETURNX:Next Month Return
      # SAUTH:Simple Authorization

      def initialize(
        travel_package,
        credit_cards_attributes: {},
        credit_card_instance: nil,
        customer_user: nil
      )

        @processing_type = processing_type
        @travel_package = travel_package
        @amount = travel_package.processed_total_price
        @order_id = travel_package.order_id

        @credit_card_instance = credit_card_instance
        @credit_cards_attributes = credit_cards_attributes
        @customer_user = customer_user

        super()
      end


      # Success Response
      # {"ACS"=>"0",
      #   "OrderID"=>"CampsiteBooking285",
      #   "Forward"=>"2a99662",
      #   "Method"=>"1",
      #   "PayTimes"=>"",
      #   "Approve"=>" 022776",
      #   "TranID"=>"2111071411111111111111811626",
      #   "TranDate"=>"20211107143628",
      #   "CheckString"=>"94d8b1af0566c3e975920c5cfd369ca5"}

      def perform_temporary_sale(is_part_of_actual_sale=false)
        result = gmo_shop.exec_tran(
          order_id: order_id,
          access_id: access_credentials['AccessID'],
          access_pass: access_credentials['AccessPass'],
          method: 1,
          pay_times: PAY_TIMES,
          card_no: credit_card_instance.number,
          expire: "#{credit_card_instance.exp_year.to_s.last(2)}#{credit_card_instance.exp_month.to_s.rjust(2, '0')}", #format must be YYMM
          client_field1: customer_user_data
        )

        if !is_part_of_actual_sale
          travel_package.mailer.send_temporary_sale_email_to_customer(travel_package).deliver_now
          travel_package.mailer.send_temporary_sale_email_to_admin(travel_package).deliver_now
        end

        result.merge(access_credentials.slice('AccessID', 'AccessPass'))
      end

      def perform_actual_sale_directly
        perform_temporary_sale(true)

        result = gmo_shop.alter_tran(
          access_id: access_credentials['AccessID'],
          access_pass: access_credentials['AccessPass'],
          job_cd: "SALES",
          amount: amount
        )

        travel_package.mailer.send_actual_sale_email_to_customer(travel_package).deliver_now
        # travel_package.mailer.send_actual_sale_email_to_admin(travel_package).deliver_now

        result.merge(access_credentials.slice('AccessID', 'AccessPass'))
      end

      def perform_actual_sale_for(transaction)
        result = gmo_shop.alter_tran(
          access_id: transaction.access_id,
          access_pass: transaction.access_pass,
          job_cd: "SALES",
          amount: transaction.amount.to_i
        )

        travel_package.mailer.send_actual_sale_reminder_email_to_customer(travel_package).deliver_now
        travel_package.mailer.send_actual_sale_reminder_email_to_admin(travel_package).deliver_now
        travel_package.mailer.send_actual_sale_email_to_customer(travel_package).deliver_now
        # travel_package.mailer.send_actual_sale_email_to_admin(travel_package).deliver_now

        result
      end

      private

      def access_credentials
        return @credentials if @credentials.present?

        existing_gmo_transaction = gmo_shop.search_trade(
          order_id: order_id
        ) rescue nil

        if existing_gmo_transaction.present?
          raise 'invalid status' if existing_gmo_transaction['Status'] != 'UNPROCESSED'
        end

        @credentials =  existing_gmo_transaction ||
                        gmo_shop.entry_tran(
                          order_id: order_id,
                          job_cd: "AUTH",
                          amount: amount
                        )
      end

      def customer_user_data
        customer_user.to_json
      end

    end
  end
end
