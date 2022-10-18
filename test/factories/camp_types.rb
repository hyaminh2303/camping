FactoryBot.define do
  factory :camp_type do
    name { "MyString" }
  end
end

# == Schema Information
#
# Table name: camp_types
#
#  id           :bigint           not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  camp_type_id :bigint           not null
#
