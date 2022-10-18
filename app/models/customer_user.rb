class CustomerUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :credit_cards, dependent: :destroy
  has_many :travel_packages, dependent: :destroy
  has_many :booking_message_details, as: :owner, dependent: :destroy
  belongs_to :country, class_name: 'Master::Country', optional: true

  validates :last_name, :first_name, :post_code, :address, :phone_number, presence: true
  validates :phone_number, phone: true
  validates_date :birthday, on: :update, before: Date.today, before_message: :invalid_birthday


  def current_travel_package_of_camp_car_booking
    self.travel_packages.with_status(:incomplete).with_booking_type(:camp_car_booking).last
  end

  def clean_up_old_incomplete_travel_package_of_camp_car_booking
    self.travel_packages.with_status(:incomplete).with_booking_type(:camp_car_booking).destroy_all
  end

  def current_travel_package_of_campsite_booking
    self.travel_packages.with_status(:incomplete).with_booking_type(:campsite_booking).last
  end

  def clean_up_old_incomplete_travel_package_of_campsite_booking
    self.travel_packages.with_status(:incomplete).with_booking_type(:campsite_booking).destroy_all
  end

  def full_name
    "#{last_name} #{first_name}"
  end

end

# == Schema Information
#
# Table name: customer_users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  birthday               :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  post_code              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  country_id             :bigint
#
# Indexes
#
#  index_customer_users_on_country_id            (country_id)
#  index_customer_users_on_email                 (email) UNIQUE
#  index_customer_users_on_reset_password_token  (reset_password_token) UNIQUE
#
