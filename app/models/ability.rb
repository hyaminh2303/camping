# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(admin, params)
    @admin = admin
    @params = params

    return actions_permitted_for_super_admin if @admin.is_super_admin?
    return actions_permitted_for_campsite_admin if @admin.is_campsite_admin?
    return actions_permitted_for_camp_car_admin if @admin.is_camp_car_admin?
  end

  def actions_permitted_for_super_admin
    can :manage, :all

  end

  def actions_permitted_for_campsite_admin
    can :manage, CampsitePlan
    can :show, SupplierCompany do |company|
      company.id == @admin.supplier_company.id
    end

    can :manage, Campsite
    can :manage, CampsitePlanOption
    can :manage, CampsiteBooking
    can :manage, Notice
    if @params[:item_type] != 'campsite'
      cannot :read, Notice
    end
    can :manage, DateSetting
    can :manage, ChildAndPetSetting
    can :manage, :campsite_sale_management

  end

  def actions_permitted_for_camp_car_admin
    can :show, SupplierCompany do |company|
      company.id == @admin.supplier_company.id
    end

    can :manage, CampCar
    can :manage, CampCarOption
    can :manage, CampCarBooking
    can :manage, Notice
    if @params[:item_type] != 'camp_car'
      cannot :read, Notice
    end
    can :manage, RecommendedCampItem

  end

end
