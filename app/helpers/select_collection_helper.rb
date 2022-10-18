module SelectCollectionHelper
  def campsite_supplier_companies_collection
    CampsiteSupplierCompany.recent.map{|company|[ company.company_name, company.id]}
  end

  def camp_types_collection
    CampType.all.map{|camp_type|[ camp_type.name, camp_type.id]}
  end

  def campsites_collection
    Campsite.all.map{|campsite| [campsite.name, campsite.id]}
  end

  def campsites_with_campsite_plan_options_collection
    Campsite.all.map do |campsite|
      [
        campsite.name,
        campsite.id,
        { data:
          {
            campsite_plan_options: campsite.campsite_plan_options.map{|o| {id: o.id, label: o.name}}
          }
        }
      ]
    end
  end

  def camp_cars_collection
    CampCar.all.map{|camp_car| [camp_car.name, camp_car.id]}
  end

  def campsite_plan_price_date_types_collection
    CampsitePlanPrice::date_range_types.keys.map{|key| [t("campsite_plan_price.date_range_types.#{key}"), key]}
  end

  def campsite_plan_fees_collection
    CampsitePlanFee.all.map{|campsite_plan_fee| [
      t("campsite_plan_fee.plan_fee_types.#{campsite_plan_fee.plan_fee_type}"),campsite_plan_fee.id
    ]}
  end

  def camp_car_supplier_companies_collection
    CampCarSupplierCompany.recent.map do |company|
      [
        company.company_name,
        company.id,
      ]
    end
  end

  def states_collection
    Master::State.order_by_weight_asc.map do |state|
      [
        state.name,
        state.id,
        { data: { prefectures: prefectures_data(state.prefectures) } }
      ]
    end
  end

  def cities_collection
    Master::City.all.map do |city|
      [
        city.name,
        city.id,
      ]
    end
  end

  def roles_collection
    AdminUser::ROLES.map do |role|
      [t("activerecord.enum.admin_user.role.#{role}"), role]
    end
  end

  def campsite_plan_fee_types_collection
    CampsitePlanFee::fee_types.keys.map{|key| [I18n.t("activerecord.enum.campsite_plan_fee.fee_type.#{key}"), key]}
  end

  def child_and_pet_setting_types_collection
    ChildAndPetSetting::entity_types.map do |key, value|
      [I18n.t("activerecord.enum.child_and_pet_setting.entity_type.#{key}"), key]
    end
  end

  def blog_categories_collection(category_type)
    BlogCategory.with_category_type(category_type).map{|blog_category| [blog_category.name, blog_category.id]}
  end

  def camp_categories_of_facility_type_group
    return if CampCategoryGroup.facility_type_plan.blank?

    CampCategoryGroup.facility_type_plan.camp_categories.map do |category|
      {
        name: category.name,
        id: category.id
      }
    end
  end

  def campsite_plan_options_collection
    CampsitePlanOption.all.map {|campsite_plan_option| [campsite_plan_option.name, campsite_plan_option.id]}
  end

  def camp_car_options_collection
    CampCarOption.all.map do |camp_car_option|
      [camp_car_option.name, camp_car_option.id]
    end
  end

  def countries_collection
    Master::Country.all.map do |country|
      [
        I18n.t("helpers.select_collection.countries.#{country.code}"),
        country.id
      ]
    end
  end

  def classification_day_settings_collection
    ClassificationDaySetting.all.map do |classification_day_setting|
      [classification_day_setting.name, classification_day_setting.id]
    end
  end

  def campsites_group_by_supplier_company_collection
    Campsite.without_keep_private.map do |o|
      { company_id: o.supplier_company_id, id: o.id, label: o.name }
    end.group_by { |o| o[:company_id] }
  end

  def camp_cars_group_by_supplier_company_collection
    CampCar.all.map do |o|
      { company_id: o.supplier_company_id, id: o.id, label: o.name }
    end.group_by { |o| o[:company_id] }
  end

  def customer_users_collection
    CustomerUser.all.map {|customer_user| [customer_user.email, customer_user.id]}
  end

  def campsite_plans_collection
    CampsitePlan.all.map { |campsite_plan| [campsite_plan.name, campsite_plan.id] }
  end

  def contract_type_collection
    SupplierCompany.contract_type.values.map {|contract_type| [t("activerecord.enum.supplier_company.contract_type.#{contract_type}"), contract_type]}
  end

  def months_collection
    (1..12).map{|x| [(x < 10 ? "0#{x}" : x ), x]}
  end

  private

  def prefectures_data(prefectures)
    result = {}
    prefectures.each do |prefecture|
      result["#{prefecture.id}"] = {
        name: prefecture.name,
        cities: cities_data(prefecture.cities)
      }
    end

    result
  end

  def cities_data(cities)
    result = {}
    cities.each do |city|
      result["#{city.id}"] = {
        name: city.name,
      }
    end

    result
  end

  def slider_banner_pages_collection
    SliderBanner::pages.keys.map{ |key| [t("activerecord.enum.slider_banner.page.#{key}"), key] }
  end

  def booking_statuses_collection(is_searching=false)
    (TravelPackage::status.values - ['incomplete']).map do |status|
      option = [t("activerecord.enum.travel_package.status.#{status}"), status]

      if status == 'canceled' && !is_searching
        option << { disabled: true }
      end

      option
    end.reverse
  end
end
