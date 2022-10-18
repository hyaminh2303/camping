require "rails_helper"

RSpec.describe CustomerUser, type: :model do
  it "generates token" do
    customer = build(:customer_user)
    customer.regenerate_auth_token
    expect(customer.tokens.size).to eq(1)
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
