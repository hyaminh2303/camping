class Admin::ContactUsController < Admin::AdminController
  authorize_resource

  def index
    @contact_us = ContactUs.page(params[:page]).order(created_at: :desc)
  end

  def show
    @contact_us = ContactUs.find(params[:id])
  end

end