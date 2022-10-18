module Admin
  class RecommendedCampItemsController < AdminController
    before_action :validate_recommended_camp_item_type
    before_action :set_recommended_camp_item, only: %i[ show edit update destroy ]
    authorize_resource

    def index
      @recommended_camp_items = RecommendedCampItem.with_item_type(params[:item_type]).order(weight: :asc).page(params[:page])
    end

    def new
      @recommended_camp_item = RecommendedCampItem.new
    end

    def show; end

    def edit; end

    def create
      @recommended_camp_item = RecommendedCampItem.new(recommended_camp_item_params)
      @recommended_camp_item.item_type = params[:item_type]

      if @recommended_camp_item.save
        redirect_to admin_recommended_camp_item_path(params[:item_type], @recommended_camp_item), notice: I18n.t("controllers.created", model: RecommendedCampItem.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @recommended_camp_item.update(recommended_camp_item_params)
        redirect_to admin_recommended_camp_item_path(params[:item_type], @recommended_camp_item), notice: I18n.t("controllers.updated", model: RecommendedCampItem.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @recommended_camp_item.destroy
      redirect_to admin_recommended_camp_items_path(params[:item_type]), notice: I18n.t("controllers.deleted", model: RecommendedCampItem.model_name.human)
    end

    private

    def validate_recommended_camp_item_type
      if [
          'camp_car',
          'campsite'
        ].exclude?(params[:item_type]) || !valid_admin_role?

        redirect_to admin_root_path, notice: "Invalid recommended camp item type"
      end
    end

    def valid_admin_role?
      # Supper admin can do anything and visit any page
      return true if current_admin_user.is_super_admin?

      (params[:item_type] == 'camp_car' && current_admin_user.is_camp_car_admin?) ||
      (params[:item_type] == 'campsite' && current_admin_user.is_campsite_admin?)
    end

    def set_recommended_camp_item
      @recommended_camp_item = RecommendedCampItem.with_item_type(params[:item_type]).find(params[:id])
    end

    def recommended_camp_item_params
      params.require(:recommended_camp_item).permit(
        :supplier_company_id,
        :recommended_itemable_id,
        :weight
      )
    end
  end
end
