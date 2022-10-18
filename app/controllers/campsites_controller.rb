class CampsitesController < ApplicationController
  before_action :set_campsite, only: [:show]

  def index
    # @recommended_campsites = RecommendedCampItem.order_by(:campsite, :asc).map(&:recommended_itemable)
    #https://app.clickup.com/t/213ndvf
    @recommended_campsites = RecommendedCampItem.order_by(:campsite, :asc).
                                                map(&:recommended_itemable).
                                                select{|x| x.keep_private == false}
    @blog_categories = BlogCategory.all
  end

  def search
    @campsite_search_service = CampsiteSearchService.new(params)
    @campsites = @campsite_search_service.run.page(params[:page]).per(10)
    @campsites_without_searching_category = @campsite_search_service.run(false)
    @supplier_blogs = Blog.top_page.with_blog_type(:supplier_blog).order(created_at: :desc).limit(4)
  end

  def show
    #https://app.clickup.com/t/213ndvf
    if @campsite.keep_private
      redirect_to root_path, alert: t('campsites.error_messages.not_found')
    end

    @notice = @campsite.notices.without_keep_private.last
  end

  private

  def set_campsite
    @campsite = Campsite.find params[:id]
  end

end
