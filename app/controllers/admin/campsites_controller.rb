module Admin
  class CampsitesController < AdminController
    before_action :set_campsite, only: %i[ show edit update destroy ]
    authorize_resource

    def index
      @q = Campsite.ransack(params[:q])
      @campsites = @q.result.includes(:campsite_supplier_company).
                   with_translations(I18n.locale).
                   with_prefecture_translations(I18n.locale).
                   page(params[:page])
    end

    def show
    end

    def new
      @campsite = Campsite.new
      campsite_entrance_fee = @campsite.build_campsite_entrance_fee
      ensure_child_and_pet_entrance_fees_are_up_to_date_for(campsite_entrance_fee)
    end

  def reload_child_and_pet_entrance_fees_form
      @campsite = Campsite.find_by(id: params[:campsite_id]) || Campsite.new
      @campsite.supplier_company_id = params[:supplier_company_id]
      campsite_entrance_fee = @campsite.campsite_entrance_fee || @campsite.build_campsite_entrance_fee
      ensure_child_and_pet_entrance_fees_are_up_to_date_for(campsite_entrance_fee)
    end

    def edit
      campsite_entrance_fee =
        @campsite.campsite_entrance_fee || @campsite.build_campsite_entrance_fee
      ensure_child_and_pet_entrance_fees_are_up_to_date_for(campsite_entrance_fee)
    end

    def create
      @campsite = Campsite.new(campsite_params)

      if @campsite.save
        redirect_to [:admin, @campsite], notice: I18n.t("controllers.created", model: Campsite.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @campsite.update(campsite_params)
        redirect_to [:admin, @campsite], notice: I18n.t("controllers.updated", model: Campsite.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @campsite.destroy
      redirect_to admin_campsites_url, notice: I18n.t("controllers.deleted", model: Campsite.model_name.human)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_campsite
      @campsite = Campsite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def campsite_params
      while_list = [
        :unique_id,
        :name,
        :tag_list,
        :address,
        :contact_number,
        :state_id,
        :prefecture_id,
        :city_id,
        :basic_fee,
        :extra_person_fee,
        :number_of_people_pet_included,
        :description,
        :facilities_equipment,
        :business_information,
        :longitude,
        :latitude,
        :post_code,
        :keep_private,
        :fax,
        :email_address,
        camp_type_ids: [],
        camp_category_ids: [],
        photos_attributes: [:id, :image, :_destroy],
        campsite_content_photos_attributes: [
          :id,
          :_destroy,
          photo_attributes: [:id, :image]
        ],
        campsite_entrance_fee_attributes: [
          :id,
          :adult_fee,
          child_and_pet_entrance_fees_attributes: [
            :id,
            :child_and_pet_setting_id,
            :fee_value,
            :_destroy
          ]
        ]
      ]

      if current_admin_user.is_super_admin?
        while_list << :supplier_company_id

        while_list << {
          bank_attributes: [
            :id,
            :name,
            :branch_name,
            :account_type,
            :account_number,
            :account_holder,
            :account_holder_frigana,
            :_destroy
          ]
        }
      end

      params.require(:campsite).permit(
        while_list + Campsite.globalize_attribute_names + I18n.available_locales.map{|locale| "tags_#{locale}_list"}
      )
    end

    def ensure_child_and_pet_entrance_fees_are_up_to_date_for(campsite_entrance_fee)
      @campsite.child_and_pet_settings.each do |child_and_pet_setting|
        campsite_entrance_fee.child_and_pet_entrance_fees.find_or_initialize_by(
          child_and_pet_setting: child_and_pet_setting
        )
      end

      destroy_child_and_pet_entrance_fees_belong_to_campsite_supplier_company_other_for(campsite_entrance_fee)
    end

    def destroy_child_and_pet_entrance_fees_belong_to_campsite_supplier_company_other_for(campsite_entrance_fee)
      child_and_pet_setting_ids = @campsite.child_and_pet_settings.pluck(:id)

      campsite_entrance_fee.child_and_pet_entrance_fees.each do |child_and_pet_entrance_fee|
        child_and_pet_entrance_fee._destroy = child_and_pet_setting_ids.exclude?(child_and_pet_entrance_fee.child_and_pet_setting_id)
      end
    end
  end
end
