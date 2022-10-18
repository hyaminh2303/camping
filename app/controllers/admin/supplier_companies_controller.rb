module Admin
  class SupplierCompaniesController < AdminController
    before_action :validate_supplier_company_type
    before_action :set_admin_supplier_company, only: %i[ show edit update destroy ]
    authorize_resource

    def index
      @q = resource.includes(
                    :supplier_corporate_representative_information,
                    :supplier_contact_information).ransack(params[:q])
      @supplier_companies = @q.result
    end

    def show
    end

    def new
      @supplier_company = resource.new
    end

    def edit
    end

    def create
      @supplier_company = resource.new(admin_supplier_company_params)

      if @supplier_company.save
        redirect_to admin_supplier_company_path(params[:supplier_company_type], @supplier_company), notice: I18n.t("controllers.created", model: @supplier_company.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @supplier_company.update(admin_supplier_company_params)
        redirect_to admin_supplier_company_path(params[:supplier_company_type], @supplier_company), notice: I18n.t("controllers.updated", model: @supplier_company.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @supplier_company.destroy
      redirect_to admin_supplier_companies_url, notice: I18n.t("controllers.deleted", model: @supplier_company.model_name.human)
    end

    private

    def validate_supplier_company_type
      if [
          'camp_car_supplier_company',
          'campsite_supplier_company'
        ].exclude?(params[:supplier_company_type])

        redirect_to admin_root_path, notice: "Invalid supplier type"
      end
    end

    def resource
      params[:supplier_company_type].classify.constantize
    end

    def set_admin_supplier_company
      @supplier_company = if current_admin_user.is_super_admin?
                            resource.find(params[:id])
                          else
                            current_admin_user.supplier_company
                          end
    end

    def admin_supplier_company_params
      white_list = [
        :operation_classification, :company_name,
        :corporate_name_kana, :phone_number,
        :fax, :post_code, :location, :hp_url,:ryokan,
        :is_reflect_in_sales_management, :contract_start_date,
        supplier_corporate_representative_information_attributes: [
          :name_of_representative,:name_of_representative_kana,
          :position,:email_address
        ],
        supplier_contact_information_attributes: [
          :name_of_person_in_charge,:person_in_charge_name_kana,
          :phone_number,:fax,:email_address,:location,
          :accounting_personnel_information
        ],
        accountant_attributes: [
          :name, :name_phonetic, :phone_number, :email
        ]
      ]

      if current_admin_user.is_super_admin? && resource == CampsiteSupplierCompany
        white_list << :contract_type
      end

      if current_admin_user.is_super_admin?
        white_list << :note
      end

      params.require(resource.name.underscore).permit(white_list)
    end
  end
end
