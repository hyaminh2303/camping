class CampsiteSearchService
  attr_accessor :city, :prefecture, :state, :campsites
  attr_reader :params, :start_date, :end_date

  def initialize(params={})
    @params = params
    self.city = Master::City.find_by(id: params[:city])
    self.prefecture = Master::Prefecture.find_by(id: params[:prefecture])
    self.state = Master::State.find_by(id: params[:state])
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def run(is_with_category=true)
    # self.campsites = Campsite.all # https://app.clickup.com/t/26a6ngd
    self.campsites = Campsite.without_keep_private #https://app.clickup.com/t/213ndvf

    if start_date.present? && end_date.present?
      public_campsite_plans = CampsitePlan.public_plans
      public_campsite_plans = public_campsite_plans.available_in_date_range(start_date.to_date, end_date.to_date)
      self.campsites = Campsite.by_id(public_campsite_plans.pluck(:campsite_id))
    end

    self.campsites = self.campsites.by_state(state.id) if state.present?
    self.campsites = self.campsites.by_prefecture(prefecture.id) if prefecture.present?
    self.campsites = self.campsites.by_city(city.id) if city.present?

    if is_with_category && params[:c_cate].present?
      campsite_ids_by_categories =
        CampsiteCampCategory.by_camp_categories(params[:c_cate]).pluck(:campsite_id)

      self.campsites = self.campsites.by_id(campsite_ids_by_categories)
    end

    self.campsites
  end

  def get_searching_location_name
    return city.name if city.present?
    return prefecture.name if prefecture.present?
    return state.name if state.present?
  end

  private
end