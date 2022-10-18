module ComingSoon
  extend ActiveSupport::Concern

  def render_coming_soon
    return render 'shared/coming_soon'
  end

end