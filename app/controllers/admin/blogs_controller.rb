class Admin::BlogsController < Admin::AdminController
  before_action :validate_blog_type
  before_action :set_blog, only: %i[show edit update destroy]
  authorize_resource

  def index
    @blogs = Blog.with_blog_type(params[:blog_type]).page(params[:page]).order(created_at: :desc)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      redirect_to admin_blog_path(@blog, blog_type: params[:blog_type]),
                  notice: I18n.t("controllers.created", model: Blog.human_attribute_name(params[:blog_type]))
    else
      render :new, alert: @blog.errors.full_messages
    end
  end

  def show; end

  def edit; end

  def update
    if @blog.update(blog_params)
      redirect_to admin_blog_path(@blog, blog_type: params[:blog_type]),
                  notice: I18n.t("controllers.updated", model: Blog.human_attribute_name(params[:blog_type]))
    else
      render :edit, alert: @blog.errors.full_messages
    end
  end

  def destroy
    @blog.destroy
    redirect_to admin_blogs_path(blog_type: params[:blog_type]),
                notice: I18n.t("controllers.deleted", model: Blog.human_attribute_name(params[:blog_type]))
  end

  private

  def validate_blog_type
    blog_types = if current_admin_user.is_super_admin?
                  Blog::blog_type.values
                else
                  [Blog::blog_type.values[1]] # supplier admin only available to manage supplier blog
                end

    if blog_types.exclude?(params[:blog_type])
      redirect_back(fallback_location: admin_root_path)
    end
  end

  def blog_params
    while_list = [
      :title,
      :tag_list,
      :description,
      :area_list,
      :blog_type,
      :content,
      :blog_category_id,
      :to_top_page,
      :keep_private,
      :publish_date,
      photo_attributes: [:id, :image, :_destroy]
    ]

    params.require(:blog).permit(
      while_list + Blog.globalize_attribute_names + I18n.available_locales.map{|locale| "tags_#{locale}_list"} + I18n.available_locales.map{|locale| "areas_#{locale}_list"}
    )
  end

  def set_blog
    @blog = Blog.find params[:id]
  end
end