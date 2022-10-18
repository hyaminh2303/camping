class Admin::BlogCategoriesController < Admin::AdminController
  before_action :validate_category_type
  before_action :set_blog_category, only: %i[show edit update destroy]
  authorize_resource

  def index
    @blog_categories = BlogCategory.with_category_type(params[:category_type]).page(params[:page]).order(created_at: :desc)
  end

  def new
    @blog_category = BlogCategory.new
  end

  def create
    @blog_category = BlogCategory.new(blog_category_params)
    @blog_category.category_type = params[:category_type] # only create category type here to avoid supplier updating in the future

    if @blog_category.save
      redirect_to admin_blog_category_path(@blog_category, category_type: params[:category_type]),
                  notice: I18n.t("controllers.created", model: BlogCategory.human_attribute_name(params[:category_type]))
    else
      render :new, alert: @blog_category.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @blog_category.update(blog_category_params)
      redirect_to admin_blog_category_path(@blog_category, category_type: params[:category_type]),
                  notice: I18n.t("controllers.updated", model: BlogCategory.human_attribute_name(params[:category_type]))
    else
      render :edit, alert: @blog_category.errors.full_messages
    end
  end

  def destroy
    @blog_category.destroy
    redirect_to admin_blog_categories_path(category_type: params[:category_type]),
                notice: I18n.t("controllers.deleted", model: BlogCategory.human_attribute_name(params[:category_type]))
  end

  private

  def blog_category_params
    while_list = [
      :name,
      :weight,
      :icon,
      :category_type
    ]

    params.require(:blog_category).permit(
      while_list + Campsite.globalize_attribute_names
    )
  end

  def set_blog_category
    @blog_category = BlogCategory.find params[:id]
  end

  def validate_category_type
    category_types = BlogCategory::category_type.values

    if category_types.exclude?(params[:category_type])
      redirect_back(fallback_location: admin_root_path)
    end
  end
end