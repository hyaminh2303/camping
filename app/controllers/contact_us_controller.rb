class ContactUsController < ApplicationController

  def new
    @contact_us = ContactUs.new
  end

  def confirm_information
    @contact_us = ContactUs.new(contact_us_params)
    if !@contact_us.valid?
      render :new
    end
  end

  def create
    @contact_us = ContactUs.new(contact_us_params)
    if @contact_us.save
      ContactUsMailer.send_contact_us_confirmation_to_customer(@contact_us).deliver_now
      ContactUsMailer.send_customer_inquiry_detail_email_to_admin(@contact_us).deliver_now

      redirect_to thanks_contact_us_path
    else
      render :new
    end
  end

  def thanks; end

  private

  def contact_us_params
    params.require(:contact_us).permit(
      :name,
      :email,
      :phone_number,
      :details_of_inquiry
    )
  end

end