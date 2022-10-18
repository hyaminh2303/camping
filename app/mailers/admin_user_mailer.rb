class AdminUserMailer < ApplicationMailer
  def update_to_actual_sale_for_gmo_transaction_failed(gmo_transaction, error)
    @gmo_transaction = gmo_transaction
    @error = error

    mail(
      to: Settings.admin_email,
      subject: 'Update to actual sale failed'
    )
  end

end