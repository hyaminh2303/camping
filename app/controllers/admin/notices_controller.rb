module Admin
  class NoticesController < Admin::AdminController
    before_action :set_notice, only: %i[ show edit update destroy ]
    authorize_resource
    before_action :validate_notice_item_type

    def index
      @notices = Notice.with_item_type(params[:item_type]).order_publish_date_desc_null_last.page(params[:page])
    end

    def new
      @notice = Notice.new
    end

    def edit; end

    def show; end

    def create
      @notice = Notice.new(notice_params)
      @notice.item_type = params[:item_type]

      if @notice.save
        redirect_to [:admin, @notice, item_type: params[:item_type]], notice: I18n.t("controllers.created", model: Notice.human_attribute_name(params[:item_type]))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @notice.update(notice_params)
        redirect_to [:admin, @notice, item_type: params[:item_type]], notice: I18n.t("controllers.updated", model: Notice.human_attribute_name(params[:item_type]))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @notice.destroy
      redirect_to [:admin, @notice, item_type: params[:item_type]], notice: I18n.t("controllers.deleted", model: Notice.human_attribute_name(params[:item_type]))
    end

    private

    def set_notice
      @notice = Notice.find(params[:id])
    end


    def notice_params
      while_list = [
        :keep_private,
        :title,
        :content,
        :notice_itemable_id,
        :publish_date,
        photo_attributes: [:id, :image, :_destroy],
      ]

      if current_admin_user.is_super_admin?
        while_list << :supplier_company_id
      end

      params.require(:notice).permit(while_list + Notice.globalize_attribute_names)
    end

    def validate_notice_item_type
      if [
        'campsite',
        'camp_car',
        'super_admin'
      ].exclude?(params[:item_type]) || !valid_admin_role?

        redirect_back(fallback_location: admin_root_path, notice: 'Invalid notice item')
      end
    end

    def valid_admin_role?
      # Supper admin can do anything and visit any page
      return true if current_admin_user.is_super_admin?

      (params[:item_type] == 'campsite' && current_admin_user.is_campsite_admin?) ||
      (params[:item_type] == 'camp_car' && current_admin_user.is_camp_car_admin?)
    end

  end
end