class Master::Country < ApplicationRecord
  has_many :customer_users

end

# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
