FactoryBot.define do
  factory :city, class: 'Master::City' do
    prefecture
    name { 'Thu Duc' }
  end
end

# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  code          :string
#  name          :string
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :bigint           not null
#  prefecture_id :bigint
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
