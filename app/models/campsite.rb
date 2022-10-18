class Campsite < ApplicationRecord
  include SupplierCompanyAsTenant

  I18n.available_locales.each do |locale|
    acts_as_taggable_on "tags_#{locale}"
  end

  has_one :campsite_entrance_fee, dependent: :destroy
  has_one :bank, as: :bankable, dependent: :destroy
  has_many :notices, as: :notice_itemable, dependent: :destroy
  has_many :campsite_camp_categories, dependent: :destroy
  has_many :camp_categories, through: :campsite_camp_categories, validate: false
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :campsite_content_photos, dependent: :destroy
  has_many :campsite_plans, dependent: :destroy
  has_many :recommended_camp_items, as: :recommended_itemable, dependent: :destroy
  has_many :campsite_plan_options, dependent: :destroy
  has_many :child_and_pet_settings, dependent: :destroy
  has_many :date_settings, dependent: :destroy

  has_and_belongs_to_many :camp_types

  belongs_to :campsite_supplier_company, foreign_key: :supplier_company_id
  belongs_to :state, class_name: 'Master::State'
  belongs_to :prefecture, class_name: 'Master::Prefecture'
  belongs_to :city, class_name: 'Master::City'

  mount_uploader :attachment, ImageUploader # https://app.clickup.com/t/1qeeqrx

  translates :name, :address, :business_information, :description,
             :about_cancellation, :peripheral_facilities
  globalize_accessors locales: I18n.available_locales, attributes: [
    :name,
    :address,
    :business_information,
    :description,
    :about_cancellation,
    :peripheral_facilities
  ]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  accepts_nested_attributes_for :camp_types
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :campsite_content_photos, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :campsite_entrance_fee
  accepts_nested_attributes_for :bank, reject_if: :all_blank

  before_validation :destroy_invalid_campsite_camp_categories
  # before_validation :set_supplier_company_for_tenancy

  validates :name, :basic_fee, :number_of_people_pet_included,
            :extra_person_fee, :address, :about_cancellation, presence: true
  validates :basic_fee, :number_of_people_pet_included, :extra_person_fee, numericality: { greater_than_or_equal_to: 0 }
  validates :attachment, format: { with: %r{\.(png|jpg|jpeg)\z}i, message: I18n.t('activerecord.errors.messages.validate_image_file_type') },
                          if: proc { attachment.present? }
  # Add all your validations before
  validate :validates_globalized_attributes

  attr_accessor :old_supplier_company_id
  before_update do
    self.old_supplier_company_id = self.supplier_company_id_was
  end

  scope :by_id, -> (ids) { where(id: ids) }
  scope :by_state, -> (state) { where(state_id: state) }
  scope :by_prefecture, -> (prefecture) { where(prefecture_id: prefecture) }
  scope :by_city, -> (city) { where(city_id: city) }
  scope :by_supplier_company_ids, -> (supplier_company_ids) { where(supplier_company_id: supplier_company_ids) }
  scope :only_public, -> () {
    public_campsite_plans = CampsitePlan.public_plans
    where(id: public_campsite_plans.pluck(:campsite_id))
  }
  scope :with_contract_type, -> (contract_type) {
    campsite_supplier_companies = CampsiteSupplierCompany.with_contract_type(contract_type)
    where(supplier_company_id: campsite_supplier_companies.pluck(:id))
  }
  # https://app.clickup.com/t/2t7xefj
  # scope :by_year_of_contract_start_date, -> (year) {
  #   left_outer_joins(:campsite_supplier_company).where('extract(year from contract_start_date) = ?', year)
  # }
  # scope :by_month_of_contract_start_date, -> (month) {
  #   left_outer_joins(:campsite_supplier_company).where('extract(month from contract_start_date) = ?', month)
  # }
  scope :without_keep_private, -> () { where(keep_private: false)} #https://app.clickup.com/t/213ndvf
  scope :with_prefecture_translations, -> (locale) {
    includes(prefecture: :translations).where(prefecture_translations: {locale: locale})
  }
  scope :search_name_by, -> (keywords, locale = I18n.locale) {
    with_translations(locale).where('campsite_translations.name ILIKE ?', "%#{keywords}%")
  }
  scope :only_reflect_in_sales_management, -> {
    includes(:campsite_supplier_company).where(campsite_supplier_company: {is_reflect_in_sales_management: true})
  }

  def tags_locale_list
    send "tags_#{I18n.locale}_list"
  end

  private

  def destroy_invalid_campsite_camp_categories
    self.campsite_camp_categories.each do |campsite_camp_category|
      campsite_camp_category.destroy if campsite_camp_category.camp_category_id.blank?
    end
  end

  # def set_supplier_company_for_tenancy
  #   if ActsAsTenant.current_tenant.present?
  #     self.campsite_supplier_company = ActsAsTenant.current_tenant
  #   else
  #     self.supplier_company_id = campsite_supplier_company.id
  #   end
  # end
end

# == Schema Information
#
# Table name: campsites
#
#  id                            :bigint           not null, primary key
#  about_cancellation            :text
#  address                       :string
#  attachment                    :string
#  basic_fee                     :integer
#  business_information          :text
#  contact_number                :string
#  description                   :text
#  email_address                 :string
#  extra_person_fee              :integer
#  facilities_equipment          :text
#  fax                           :string
#  keep_private                  :boolean          default(FALSE)
#  latitude                      :float
#  longitude                     :float
#  name                          :string
#  number_of_people_pet_included :integer
#  peripheral_facilities         :text
#  post_code                     :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  city_id                       :bigint
#  prefecture_id                 :bigint
#  state_id                      :bigint
#  supplier_company_id           :integer
#  unique_id                     :string
#
# Indexes
#
#  index_campsites_on_city_id        (city_id)
#  index_campsites_on_prefecture_id  (prefecture_id)
#  index_campsites_on_state_id       (state_id)
#
