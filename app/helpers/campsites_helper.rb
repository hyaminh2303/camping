module CampsitesHelper
  def get_campsite_plan_fee(campsite_plan_fee)
    if campsite_plan_fee.fee_type == 'normal'
      campsite_plan_fee.normal_campsite_plan_fee_detail.basic_fee
    elsif campsite_plan_fee.fee_type == 'classification_day'
      campsite_plan_fee.classification_day_campsite_plan_fee_details.sum(:basic_fee)
    end

  end

  def get_day_name(date)
    I18n.t("day_name.#{date.strftime('%A').downcase}")
  end

  def state_code(params)
    state = Master::State.find_by(id: params[:state])
    prefecture = Master::Prefecture.find_by(id: params[:prefecture])
    city = Master::City.find_by(id: params[:city])

    code = if state.present?
      state.code
    elsif prefecture.present?
      prefecture.state.code
    elsif city.present?
      city.prefecture.state.code
    end

    return if code.blank?

    code.split(',')
  end

  # https://app.clickup.com/t/1ua4kgn
  # https://app.clickup.com/t/1xwm5xx
  # https://app.clickup.com/t/244x6eg

  def camp_categories_except_facility_in_the_hall_for(campsite)
    CampCategoryGroup.showed_on_the_front_end.order_by_weight_asc.except_facility_in_the_hall.map do |group|
      handle_camp_categories(group, campsite).merge(group: group)
    end
  end

  # https://app.clickup.com/t/2buq1ye
  def camp_categories_with_facility_in_the_hall_for(campsite)
    camp_category_group = CampCategoryGroup.showed_on_the_front_end.with_the_facility_in_the_hall

    return if camp_category_group.blank?

    handle_camp_categories(camp_category_group, campsite)
  end

  def handle_camp_categories(camp_category_group, campsite)
    original_camp_categories = camp_category_group.camp_categories.order_by_weight_asc
    selected_camp_categories = original_camp_categories.by_id(campsite.campsite_camp_categories.pluck(:camp_category_id))

    {
      original_camp_categories: original_camp_categories,
      selected_camp_categories: selected_camp_categories
    }
  end

  def custom_address_text_for(campsite)
    if campsite.post_code.present?
      "#{I18n.t('campsites.show.post_code')}#{campsite.post_code} #{campsite.address}"
    else
      campsite.address
    end
  end

  def count_campsites_of_group(group, campsites_without_searching_category)
    campsite_camp_categories = CampsiteCampCategory.by_camp_categories(group.camp_categories.pluck(:id))
    campsites_without_searching_category.by_id(campsite_camp_categories.pluck(:campsite_id)).count
  end

end
