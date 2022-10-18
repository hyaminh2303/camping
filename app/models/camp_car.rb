class CampCar < ApplicationRecord
  include SupplierCompanyAsTenant

  acts_as_taggable_on :tags

  belongs_to :category, class_name: 'CampCarCategory'
  belongs_to :camp_car_supplier_company, foreign_key: :supplier_company_id
  belongs_to :state, class_name: 'Master::State'
  belongs_to :prefecture, class_name: 'Master::Prefecture'
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :camp_car_bookings, dependent: :destroy
  has_many :camp_car_quantities, dependent: :destroy
  has_and_belongs_to_many :camp_car_options
  has_one :notice, as: :notice_itemable, dependent: :destroy
  has_many :recommended_camp_items, as: :recommended_itemable, dependent: :destroy

  translates :name, :description, :subtitle
  globalize_accessors locales: I18n.available_locales, attributes: [:name, :description, :subtitle]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :product_id, :name, :car_type, :category_id, :maximum_number_of_people, :fee_per_hour, :fee_per_day, presence: true
  validates :quantity, :fee_per_day, :fee_per_hour, :maximum_number_of_people, numericality: { greater_than_or_equal_to: 0 }
  # Add all your validations before
  validate :validates_globalized_attributes

  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :camp_car_quantities, reject_if: :all_blank, allow_destroy: true

  scope :only_public, -> () {where(is_public: true)}
  scope :by_state, -> (state) { where(state_id: state) }
  scope :by_prefecture, -> (prefecture) { where(prefecture_id: prefecture) }
  scope :booked_in_date_range, -> (start_date, end_date) {
    camp_car_booking = CampCarBooking.by_start_date_and_end_date(start_date, end_date)
    where(id: camp_car_booking.pluck(:camp_car_id))
  }
  scope :by_id, -> (ids) { where(id: ids) }
  scope :by_start_date_and_end_date, -> (start_date, end_date) {
    where(created_at: (start_date.in_time_zone.beginning_of_day..end_date.in_time_zone.end_of_day))
  }

  def remaining_quantity_on(date)
    # In this case, if the records were too large so loaded it's to RAM, we will use  the SQL query to the DB
    camp_car_quantity = self.camp_car_quantities.find_by(date: date)&.quantity || self.quantity
    number_of_bookings = self.camp_car_bookings.only_booked_status.by_date(date).count

    camp_car_quantity - number_of_bookings
  end

  def is_camp_car_out_of_stock?(check_in, check_out)
    (check_in..check_out).each do |date|
      return true if self.remaining_quantity_on(date) <= 0
    end

    return false
  end

  def self.available_in_date_range(start_date, end_date)
    camp_cars = all
    camp_car_ids = camp_cars.ids

    (start_date..end_date).each do |date|
      camp_cars.each do |camp_car|
        if camp_car.remaining_quantity_on(date) < 1
          camp_car_ids.delete(camp_car.id)
        end
      end
    end

    camp_cars = camp_cars.where(id: camp_car_ids)

    camp_cars
  end

  def address
  end

  def contact_number
  end

end

# == Schema Information
#
# Table name: camp_cars
#
#  id                                 :bigint           not null, primary key
#  car_type                           :string
#  description                        :text
#  fee_per_day                        :integer
#  fee_per_hour                       :integer
#  is_pick_up_and_drop_off_place_same :boolean          default(FALSE)
#  is_public                          :boolean          default(FALSE)
#  maximum_number_of_people           :integer
#  name                               :string
#  quantity                           :integer
#  subtitle                           :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  camp_car_id                        :bigint           not null
#  category_id                        :bigint
#  prefecture_id                      :integer
#  product_id                         :string
#  state_id                           :integer
#  supplier_company_id                :integer
#
# Indexes
#
#  index_camp_cars_on_category_id  (category_id)
#
