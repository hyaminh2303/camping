class CampCarSearchService
  attr_accessor :prefecture, :state, :camp_cars
  attr_reader :params, :start_date, :end_date

  def initialize(params={})
    @params = params
    self.prefecture = Master::Prefecture.find_by(id: params[:prefecture])
    self.state = Master::State.find_by(id: params[:state])
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def run
    self.camp_cars = CampCar.only_public

    self.camp_cars = self.camp_cars.by_state(state.id) if state.present?
    self.camp_cars = self.camp_cars.by_prefecture(prefecture.id) if prefecture.present?

    if start_date.present? && end_date.present?
      self.camp_cars = self.camp_cars.available_in_date_range(start_date.to_date, end_date.to_date)
    end

    self.camp_cars
  end

  def get_searching_location_name
    return prefecture.name if prefecture.present?
    return state.name if state.present?
  end

end