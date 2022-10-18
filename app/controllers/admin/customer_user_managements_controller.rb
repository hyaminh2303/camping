class Admin::CustomerUserManagementsController < Admin::AdminController
  authorize_resource class: false

  def index
    @customer_users = CustomerUser.all.page(params[:page])
  end
end
