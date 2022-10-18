class Admin::CampsitePlansController < Admin::AdminController
  before_action :set_campsite
  before_action :set_campsite_plan, only: %i[ show edit update destroy ]
  authorize_resource

  def index
    campsite_ids = Campsite.pluck(:id)
    campsite_plans = resource.with_translations(I18n.locale).with_campsite_translations(I18n.locale).by_campsite_ids(campsite_ids)
    @q = campsite_plans.ransack(params[:q])
    @campsite_plans = @q.result.page(params[:page])
  end

  def new
    @campsite_plan = resource.new
    @campsite_plan.campsite_plan_daily_fee_settings.build
    campsite_plan_fee = @campsite_plan.build_campsite_plan_fee
    campsite_plan_fee.build_normal_campsite_plan_fee_detail
    @campsite_plan.photos.build
    ensure_day_classification_campsite_plan_fee_details_are_up_to_date_for(campsite_plan_fee)
    ensure_child_and_pet_fees_are_up_to_date_for(campsite_plan_fee)
  end

  def reload_child_and_pet_fees_form
    @campsite_plan = CampsitePlan.find_by(id: params[:campsite_plan_id]) ||
                      CampsitePlan.new

    campsite_plan_fee = @campsite_plan.campsite_plan_fee || @campsite_plan.build_campsite_plan_fee
    ensure_day_classification_campsite_plan_fee_details_are_up_to_date_for(campsite_plan_fee)
    ensure_child_and_pet_fees_are_up_to_date_for(campsite_plan_fee)
  end

  def create
    @campsite_plan = CampsitePlan.new(campsite_plan_params)
    if @campsite_plan.save
      redirect_to [:admin, @campsite, @campsite_plan], notice: I18n.t("controllers.created", model: CampsitePlan.model_name.human)
    else
      render :new
    end
  end

  def edit
    campsite_plan_fee = @campsite_plan.campsite_plan_fee
    campsite_plan_fee.normal_campsite_plan_fee_detail || campsite_plan_fee.build_normal_campsite_plan_fee_detail
    ensure_day_classification_campsite_plan_fee_details_are_up_to_date_for(campsite_plan_fee)
    ensure_child_and_pet_fees_are_up_to_date_for(campsite_plan_fee)
  end

  def update
    if @campsite_plan.update(campsite_plan_params)
      redirect_to [:admin, @campsite, @campsite_plan], notice: I18n.t("controllers.updated", model: CampsitePlan.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @campsite_plan.destroy
    redirect_to [:admin, @campsite, CampsitePlan], notice: I18n.t("controllers.deleted", model: CampsitePlan.model_name.human)
  end

  def camsite_default_fee
    render json: @campsite.to_json
  end

  private

  def resource
    @campsite&.campsite_plans|| CampsitePlan
  end

  def set_campsite_plan
    @campsite_plan = CampsitePlan.find(params[:id])
  end

  def set_campsite
    @campsite ||= Campsite.find_by(id: params[:campsite_id])
  end

  def campsite_plan_params
    params.require(:campsite_plan).permit([
        :campsite_id,
        :name,
        :quantity,
        :max_number_of_people,
        :public_info,
        :check_in_time,
        :check_out_time,
        :description,
        :subtitle,
        :tag_list,
        :is_included_entrance_fee,
        campsite_plan_fee_attributes: [
          :id, :fee_type, :start_date, :end_date,

          classification_day_campsite_plan_fee_details_attributes: [
            :id, :basic_fee, :extra_person_fee, :number_of_people_pet_included,
            :classification_day_setting_id, :_destroy
          ],

          classification_day_child_and_pet_fees_attributes: [
            :id,
            :child_and_pet_setting_id,
            :classification_day_setting_id,
            :fee_value,
            :_destroy
          ],

          normal_campsite_plan_fee_detail_attributes: [
            :id, :basic_fee, :extra_person_fee, :number_of_people_pet_included
          ],

          normal_child_and_pet_fees_attributes: [
            :id,
            :child_and_pet_setting_id,
            :fee_value,
            :_destroy
          ],

          classification_day_setting_ids: []
        ],
        campsite_plan_daily_fee_settings_attributes: [
          :id, :basic_fee, :extra_person_fee, :number_of_people_pet_included, :date,
        ],
        campsite_plan_quantities_attributes: [
          :id, :date, :quantity, :_destroy
        ],
        photos_attributes: [:id, :image, :_destroy],
        campsite_plan_option_ids: []
      ] + CampsitePlan.globalize_attribute_names + I18n.available_locales.map{|locale| "tags_#{locale}_list"}
    )
  end

  def ensure_day_classification_campsite_plan_fee_details_are_up_to_date_for(campsite_plan_fee)
    # https://app.clickup.com/t/20r02ze
    campsite_id = campsite_plan_fee.campsite_plan.campsite_id
    # Get campsite from when changing campsite or campsite plan fee
    classification_day_setting_ids = DateSetting.by_campsite_id(@campsite&.id || campsite_id).
                                      pluck(:classification_day_setting_id).uniq.compact
    classification_day_campsite_plan_fee_details = campsite_plan_fee.classification_day_campsite_plan_fee_details
    # Mark classification_day_campsite_plan_fee_detail not belong to the selected campsite if changing campsite
    # Meant: If classification_day_campsite_plan_fee_detail has classification day setting not belongs to the selected campsite, then
    # classification day campsite plan fee will be destroyed when submitted the form
    classification_day_campsite_plan_fee_details.each do |classification_day_campsite_plan_fee_detail|
      classification_day_campsite_plan_fee_detail._destroy = classification_day_setting_ids.exclude?(
        classification_day_campsite_plan_fee_detail.classification_day_setting_id)
    end

    ClassificationDaySetting.by_ids(classification_day_setting_ids).each do |classification_day_setting|
      classification_day_campsite_plan_fee_details.find_or_initialize_by(
        classification_day_setting: classification_day_setting
      )
    end
  end

  def ensure_child_and_pet_fees_are_up_to_date_for(campsite_plan_fee)
    # https://app.clickup.com/t/20r02ze
    # https://app.clickup.com/t/1y26kgk
    campsite = campsite_plan_fee.campsite_plan.campsite
    # Get campsite from when changing campsite or campsite plan fee
    child_and_pet_settings = @campsite&.child_and_pet_settings || campsite&.child_and_pet_settings || []
    classification_day_setting_ids = DateSetting.by_campsite_id(@campsite&.id || campsite&.id).
                                      pluck(:classification_day_setting_id).uniq.compact
    classification_day_child_and_pet_fees = campsite_plan_fee.classification_day_child_and_pet_fees

    ClassificationDaySetting.by_ids(classification_day_setting_ids).each do |classification_day_setting|
     child_and_pet_settings.each do |child_and_pet_setting|
        classification_day_child_and_pet_fees.find_or_initialize_by(
          child_and_pet_setting: child_and_pet_setting,
          classification_day_setting: classification_day_setting
        )
      end
    end

    child_and_pet_settings.each do |child_and_pet_setting|
      campsite_plan_fee.normal_child_and_pet_fees.find_or_initialize_by(
        child_and_pet_setting: child_and_pet_setting
      )
    end
    # Child and pet fee marking will be destroyed when changing campsite on the UI
    mark_child_and_pet_fees_belong_to_campsite_other(
      campsite_plan_fee,
      child_and_pet_settings.pluck(:id),
      classification_day_setting_ids)
  end

  def mark_child_and_pet_fees_belong_to_campsite_other(campsite_plan_fee, child_and_pet_setting_ids, classification_day_setting_ids)
    # https://app.clickup.com/t/1y26kgk
    # https://app.clickup.com/t/20r02ze
    # If classification_day_child_and_pet_fee has child and pet setting and classification day setting not belongs to the selected campsite, then
    # classification day child and pet fee will be destroyed when submitted the form
    campsite_plan_fee.classification_day_child_and_pet_fees.each do |classification_day_child_and_pet_fee|
      classification_day_child_and_pet_fee._destroy =
        child_and_pet_setting_ids.exclude?(classification_day_child_and_pet_fee.child_and_pet_setting_id) ||
        classification_day_setting_ids.exclude?(classification_day_child_and_pet_fee.classification_day_setting_id)
    end

    campsite_plan_fee.normal_child_and_pet_fees.each do |normal_child_and_pet_fee|
      normal_child_and_pet_fee._destroy = child_and_pet_setting_ids.exclude?(
                                          normal_child_and_pet_fee.child_and_pet_setting_id)
    end
  end

end