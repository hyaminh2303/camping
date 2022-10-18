class CampsiteSaleManagementService
  attr_accessor :campsites, :commission_contracts, :no_commission_contracts
  attr_reader :params, :campsite_plan, :campsite_supplier_company

  def initialize(params={})
    @params = params
    @campsite_plan = CampsitePlan.find_by_id(params[:campsite_plan_id])
    @campsite_supplier_company = CampsiteSupplierCompany.find_by_id(params[:campsite_supplier_company_id])
  end

  def run
    self.campsites = Campsite.only_reflect_in_sales_management
    self.campsites = self.campsites.by_year_of_contract_start_date(params[:year]) if params[:year].present? # filter by year
    self.campsites = self.campsites.by_month_of_contract_start_date(params[:month]) if params[:month].present? # filter by month
    self.campsites = self.campsites.by_id(campsite_plan.campsite.id) if campsite_plan.present? # filter by campsite plan
    self.campsites = self.campsites.by_id(params[:campsite_id]) if params[:campsite_id].present? # filter by campsite
    self.campsites = self.campsites.by_id(campsite_supplier_company.campsites.pluck(:id)) if campsite_supplier_company.present? # filter by supplier company
    self.commission_contracts = (self.campsites.with_contract_type(:commission_base)).map do |campsite|
      campsite_plan_ids = campsite.campsite_plans.pluck :id
      travel_package_ids = TravelPackage.without_status(:canceled, :no_show).pluck :id
      campsite_bookings = CampsiteBooking.by_user_booking.with_travel_package(travel_package_ids).by_campsite_plans(campsite_plan_ids)

      total_price = TravelPackage.by_user.by_ids(campsite_bookings.pluck(:travel_package_id)).sum(:total_price)

      Hashit.new({ # covert hash to object
        campsite: campsite,
        number_of_bookings: campsite_bookings.count,
        total_price: total_price,
        total_sale: total_price - total_price * (AppSetting.instance.campsite_commission_percentage / 100)
      })
    end

    self.no_commission_contracts = (self.campsites.with_contract_type(:no_commission)).map do |campsite|
      campsite_plan_ids = campsite.campsite_plans.pluck :id
      travel_package_ids = TravelPackage.without_status(:canceled, :no_show).pluck :id
      campsite_bookings = CampsiteBooking.with_travel_package(travel_package_ids).by_campsite_plans(campsite_plan_ids)
      number_of_months = (campsite.campsite_supplier_company.contract_start_date&.to_date..Time.current.to_date).map(&:month).uniq.count

      Hashit.new({ # covert hash to object
        campsite: campsite,
        number_of_bookings: campsite_bookings.count,
        total_sale: AppSetting.instance.publication_fee * number_of_months
      })
    end

    self
  end
end
