class AdminUser < ApplicationRecord
  include SupplierCompanyAsTenant

  has_many :booking_message_details, as: :owner, dependent: :destroy

  _validators.delete(:supplier_company)

  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :supplier_company
    end
  end

  rolify before_add: :clean_up_current_roles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :supplier_company_id, presence: true, if: proc{ role.present? && role != 'super_admin' }
  validate :ensure_role_presence

  before_validation :set_supplier_company_id

  ROLES = [:super_admin, :campsite_admin, :camp_car_admin]

  ROLES.each do |role|
    define_method "add_role_#{role}" do
      add_role role
    end

    define_method "remove_role_#{role}" do
      remove_role role
    end

    define_method "is_#{role}?" do
      has_role? role
    end
  end

  def role
    roles.first&.name
  end

  def role=(value)
    if ROLES.exclude?(value.to_sym)
      @is_blank_role = true
    else
      send("add_role_#{value}")
    end
  end

  def clean_up_current_roles(current_role)
    ROLES.each do |role_name|
      send("remove_role_#{role_name}")
    end
  end

  private

  def set_supplier_company_id
    self.supplier_company_id = nil if role == 'super_admin'
  end

  def ensure_role_presence
    if @is_blank_role
      self.errors.add :role, :blank
    end
  end

end

# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  supplier_company_id    :integer
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
