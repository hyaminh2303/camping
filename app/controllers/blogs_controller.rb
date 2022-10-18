class BlogsController < ApplicationController
  before_action :validate_blog_type
  before_action :set_blog, only: %i[ show ]
  before_action :set_blog_category, only: %i[ index ]

  def index
    blogs = @blog_category.present? ? @blog_category.blogs : Blog.with_blog_type(params[:blog_type])

    @blogs = blogs.without_keep_private.page(params[:page]).order(created_at: :desc)
  end

  def show
    if @blog.keep_private
      redirect_to root_path, alert: t('blogs.error_messages.not_found')
    end

    @blog_categories = BlogCategory.with_category_type(@blog.blog_category.category_type)
  end

  private

  def set_blog
    @blog = Blog.with_blog_type(params[:blog_type]).find params[:id]
  end

  def set_blog_category
    @blog_category = BlogCategory.with_category_type(params[:blog_type]).find_by(id: params[:blog_category_id])
  end

  def validate_blog_type
    if Blog::blog_type.values.exclude? params[:blog_type]
      redirect_back(fallback_location: root_path)
    end
  end

end