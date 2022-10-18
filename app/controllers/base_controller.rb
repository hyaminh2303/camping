class BaseController < ApplicationController
  before_action :authenticate_customer_user!

end