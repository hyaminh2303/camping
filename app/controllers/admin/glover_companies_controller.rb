class Admin::GloverCompaniesController < Admin::AdminController
  before_action :set_glover_company, only: %i[ show edit update ]
  authorize_resource

  def show; end

  def edit; end

  def update
    if @glover_company.update(glover_company_params)
      redirect_to admin_glover_company_path, notice: I18n.t("controllers.updated", model: GloverCompany.model_name.human)
    else
      render :edit, alert: @glover_company.errors.full_messages
    end
  end

  private

  def set_glover_company
    @glover_company = GloverCompany.instance
  end

  def glover_company_params
    params.require(:glover_company).permit(:company_name, :location, :phone_number, :hp_url)
  end

end
