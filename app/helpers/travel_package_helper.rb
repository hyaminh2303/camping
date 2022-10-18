module TravelPackageHelper
  # Get color code from travel package booking status
  def travel_package_status_color_code(status)
    status = status&.to_sym

    code = if [:booked, :temporary_booked, :check_out].include? status
            'green'
          elsif [:canceled, :no_show].include? status
            'red'
          elsif [:incomplete].include? status
            'blue'
          end
    code
  end
end
