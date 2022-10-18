module Admin
  class SliderBannersController < AdminController
    before_action :set_slider_banner, only: %i[ show edit update destroy ]
    authorize_resource

    def index
      @slider_banners = SliderBanner.page(params[:page])
    end

    def show
    end

    def new
      @slider_banner = SliderBanner.new
    end

    def edit
    end

    def create
      @slider_banner = SliderBanner.new(slider_banner_params)

      if @slider_banner.save
        redirect_to [:admin, @slider_banner], notice: I18n.t("controllers.created", model: SliderBanner.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @slider_banner.update(slider_banner_params)
        redirect_to [:admin, @slider_banner], notice: I18n.t("controllers.updated", model: SliderBanner.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @slider_banner.destroy
      redirect_to admin_slider_banners_url, notice: I18n.t("controllers.deleted", model: SliderBanner.model_name.human)
    end

    private
    def set_slider_banner
      @slider_banner = SliderBanner.find(params[:id])
    end

    def slider_banner_params
      while_list = [
        :page,
        :position,
        slider_banner_locales_attributes: [
          :id,
          :locale,
          photos_attributes: [:id, :image, :on_click_url, :_destroy]
        ]
      ]
      params.require(:slider_banner).permit(while_list)
    end
  end
end