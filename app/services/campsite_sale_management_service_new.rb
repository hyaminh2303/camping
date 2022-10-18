class CampsiteSaleManagementServiceNew
  attr_accessor :campsites, :commission_contracts, :no_commission_contracts, :campsite_bookings, :travel_packages
  attr_reader :params, :locale

  def initialize(params={},admin_user)
    params[:year] =  Date.current.year if params[:year].nil?
    params[:month] = Date.current.month if params[:month].nil?
    params[:contract_type] = "commission_base" if params[:contract_type].nil?
    params[:contract_type] = admin_user.supplier_company.contract_type unless admin_user.is_super_admin?
    @params = params
    self.commission_contracts = []
    self.no_commission_contracts = []
  end

  def run
    filter_by_params
    filter_by_contract_type

    self
  end

  private

  def campsite_bookings_group_by_months(campsite)
    self.campsite_bookings.by_campsite(campsite.id)
                          .start_from_date_to_date(campsite.supplier_company.contract_start_date, Date.current)
                          .group_by{|campsite_booking| campsite_booking.check_in.month}
  end

  def filter_by_params
    campsite_supplier_companies = CampsiteSupplierCompany.only_reflect_in_sales_management
    campsite_supplier_companies = campsite_supplier_companies.by_id(params[:campsite_supplier_company_id]) if params[:campsite_supplier_company_id].present? #filter by supplier company id
    campsite_supplier_company_ids = campsite_supplier_companies.map(&:id)

    self.campsites = Campsite.by_supplier_company_ids(campsite_supplier_company_ids) # filter by supplier company
    self.campsites = self.campsites.by_id(params[:campsite_id]) if params[:campsite_id].present? # filter by campsite
    if params[:prefecture_name].present? #filter by prefecture
      prefecture_ids = Master::Prefecture.search_name_by(params[:prefecture_name], (params[:locale] || I18n.locale) ).pluck :id
      self.campsites = self.campsites.by_prefecture(prefecture_ids)
    end

    self.travel_packages = TravelPackage.without_status(:canceled, :no_show).with_booking_inside
    self.campsite_bookings = CampsiteBooking.with_travel_package(self.travel_packages.pluck :id)
    self.campsite_bookings = self.campsite_bookings.by_month_check_in(params[:month]) if params[:month].present? # filter by month
    self.campsite_bookings = self.campsite_bookings.by_year_check_in(params[:year]) if params[:year].present? # filter by year
  end

  def no_commission_with_month(campsite)
    campsite_bookings_in_month = campsite_bookings_group_by_months(campsite)[params[:month].to_i]
    if campsite_bookings_in_month.present?
      total_price = self.travel_packages.by_ids(campsite_bookings_in_month.pluck(:travel_package_id)).sum(:total_price)
      self.no_commission_contracts.push(
        Hashit.new({ # covert hash to object
          time: "#{params[:year]}/#{params[:month]}",
          campsite: campsite,
          number_of_bookings: campsite_bookings_in_month.count,
          total_sale: total_price
        })
      )
    else
      self.no_commission_contracts.push(
        Hashit.new({ # covert hash to object
          time: "#{params[:year]}/#{params[:month]}",
          campsite: campsite,
          number_of_bookings: 0,
          total_sale: 0
        })
      )
    end
  end

  def no_commission_not_booking(campsite)
    begin_month = if params[:year].to_i < campsite.supplier_company.contract_start_date.year
      1
    else
      campsite.supplier_company.contract_start_date.month
    end

    end_month = if params[:year].to_i < Date.current.year
      12
    else
      Date.current.month
    end

    year_month_need_show = [*begin_month..end_month].map{ |month| "#{params[:year]}/#{month}"}
    year_month_need_show.each do |time|
      self.no_commission_contracts.push(
          Hashit.new({
            time: "#{time}",
            campsite: campsite,
            number_of_bookings: 0,
            total_sale: 0
          })
        )
    end
  end

  def no_commission_have_booking(campsite)
    campsite_bookings_group_by_months(campsite).each do |month, campsite_bookings|
      no_commission_contract_overwrite = self.no_commission_contracts.find{ |s| s.campsite == campsite && s.time == "#{params[:year]}/#{month}" }
      no_commission_contract_overwrite.number_of_bookings = campsite_bookings.count
      total_price = self.travel_packages.by_ids(campsite_bookings.pluck(:travel_package_id)).sum(:total_price)
      no_commission_contract_overwrite.total_sale = total_price
    end
  end

  def filter_by_contract_type
    if(params[:contract_type] == "commission_base" || params[:contract_type].blank?)
      campsite_commission_percentage = AppSetting.instance.campsite_commission_percentage
      self.campsites.with_contract_type(:commission_base).map do |campsite|
        campsite_bookings_group_by_months(campsite).each do |month, campsite_bookings|
          total_price = self.travel_packages.by_ids(campsite_bookings.pluck(:travel_package_id)).sum(:total_price)
          self.commission_contracts.push(
            Hashit.new({ # covert hash to object
              time: "#{params[:year]}/#{month}",
              campsite: campsite,
              number_of_bookings: campsite_bookings.count,
              total_price: total_price,
              total_sale: total_price - total_price * (campsite_commission_percentage / 100)
            })
          )
        end
      end
      self.commission_contracts = self.commission_contracts.sort_by(&:time).reverse
    end

    if(params[:contract_type] == "no_commission" || params[:contract_type].blank?)
      self.campsites.with_contract_type(:no_commission).map do |campsite|
        if params[:year].to_i >= campsite.supplier_company.contract_start_date.year && params[:year].to_i <= Date.current.year #not show before contract_start_date and in future
          if params[:month].present?
            no_commission_with_month(campsite)
          else
            no_commission_not_booking(campsite)
            no_commission_have_booking(campsite)
          end
        end
      end
      self.no_commission_contracts = self.no_commission_contracts.sort_by(&:time).reverse
    end
  end
end
