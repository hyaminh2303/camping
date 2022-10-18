class ToursController < ApplicationController
  include ComingSoon

  before_action :render_coming_soon

  def index
  end

  def show
  end
end