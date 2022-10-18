class RentalCarsController < ApplicationController
  include ComingSoon

  before_action :render_coming_soon

  def index
  end

end