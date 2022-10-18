class Admin::StatesController < Admin::AdminController
  authorize_resource class: "Master::State"

  before_action :set_state, only: %i[ edit update ]

  # GET /admin/states
  def index
    @states = Master::State.order_by_weight_asc.page(params[:page])
  end

  # GET /admin/states/1/edit
  def edit
  end

  # PATCH/PUT /admin/states/1
  def update
    if @state.update(state_params)
      redirect_to edit_admin_state_path(@state), notice: I18n.t("controllers.updated", model: Master::State.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_state
    @state = Master::State.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def state_params
    white_list = [
      :name,
      :weight,
      prefectures_attributes: [
        :id,
        :_destroy,
        :name,
        cities_attributes: [
          :id,
          :_destroy,
          :name,
          :weight
        ] + Master::City.globalize_attribute_names
      ] + Master::Prefecture.globalize_attribute_names
    ] + Master::State.globalize_attribute_names

    params.require(:master_state).permit(white_list)
  end
end
