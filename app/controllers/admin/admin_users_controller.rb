module Admin
  class AdminUsersController < AdminController
    before_action :set_admin_admin_user, only: %i[ show edit update destroy ]

    authorize_resource

    # GET /admin/admin_users
    def index
      @admin_users = AdminUser.page(params[:page]).order(created_at: :desc)
    end

    # GET /admin/admin_users/1
    def show
    end

    # GET /admin/admin_users/new
    def new
      @admin_user = AdminUser.new
    end

    # GET /admin/admin_users/1/edit
    def edit
    end

    # POST /admin/admin_users
    def create
      @admin_user = AdminUser.new(admin_user_params)

      if @admin_user.save

        redirect_to [:admin, @admin_user], notice: I18n.t("controllers.created", model: AdminUser.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/admin_users/1
    def update
      if @admin_user.update(admin_user_params)

        redirect_to [:admin, @admin_user], notice: I18n.t("controllers.updated", model: AdminUser.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/admin_users/1
    def destroy
      @admin_user.destroy
      redirect_to admin_admin_users_url, notice: I18n.t("controllers.deleted", model: AdminUser.model_name.human)
    end

    private

    def set_admin_admin_user
      @admin_user = AdminUser.find(params[:id])
    end

    def admin_user_params
      white_list = [
        :email,
        :role,
        :supplier_company_id
      ]

      if action_name == 'create' || (action_name == 'update' && params[:admin_user].try(:[], :password).present?)
        white_list << :password << :password_confirmation
      end

      params.require(:admin_user).permit(white_list)
    end

  end
end
