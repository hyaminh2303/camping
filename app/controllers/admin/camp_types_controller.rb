class Admin::CampTypesController < Admin::AdminController
  before_action :set_camp_type, only: %i[show edit update destroy]
  authorize_resource

  def index
    @camp_types = CampType.page(params[:page]).order(created_at: :desc)
  end

  def new
    @camp_type = CampType.new
  end

  def create
    @camp_type = CampType.new(camp_type_params)

    if @camp_type.save
      redirect_to admin_camp_type_path(@camp_type), notice: I18n.t("controllers.created", model: CampType.model_name.human)
    else
      render :new, alert: @camp_type.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @camp_type.update(camp_type_params)
      redirect_to admin_camp_type_path(@camp_type), notice: I18n.t("controllers.updated", model: CampType.model_name.human)
    else
      render :edit, alert: @camp_type.errors.full_messages
    end
  end

  def destroy
    @camp_type.destroy
    redirect_to admin_camp_types_path(), notice: I18n.t("controllers.deleted", model: CampType.model_name.human)
  end

  private

  def camp_type_params
    params.require(:camp_type).permit(CampType.globalize_attribute_names)
  end

  def set_camp_type
    @camp_type = CampType.find params[:id]
  end
end