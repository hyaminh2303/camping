class HomeController < ApplicationController
  def index
    @glover_blog_categories = BlogCategory.with_category_type(:glover_blog).order(created_at: :desc).limit(6)
    @supplier_blogs = Blog.without_keep_private.top_page.with_blog_type(:supplier_blog).order(created_at: :desc).limit(4)
    @home_banner = SliderBanner.latest_by(:home)
    @notices = Kaminari.paginate_array(Notice.without_keep_private.with_item_type(:super_admin).order_publish_date_desc_null_last.first(3)).page(params[:page])
  end

  def contact; end

  def contact_errors; end

  def contact_confirm; end

  def contact_thanks; end

  def information; end

end
