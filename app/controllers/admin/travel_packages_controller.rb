module Admin
  class TravelPackagesController < Admin::AdminController
    before_action :set_travel_package, only: [:update_status, :cancel]

    def update_status
      if params[:travel_package].try(:[], :status).present?
        @travel_package.update(travel_package_params)
      end

      if !@travel_package.status_canceled?
        @travel_package.update(canceled_at: nil, canceled_by: nil)
      end

      redirect_back(fallback_location: root_path)
    end

    def cancel
      cancellation_service = TravelPackageCancellationService.new(@travel_package, canceled_by: current_admin_user)
      cancellation_service.run
      redirect_back(fallback_location: root_path, alert: cancellation_service.message)
    end

    private

    def travel_package_params
      params.require(:travel_package).permit(:status)
    end

    def set_travel_package
      @travel_package = TravelPackage.find(params[:id])
    end
  end
end