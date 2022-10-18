FactoryBot.define do
  factory :state, class: 'Master::State' do
    name { 'Ho Chi Minh' }
  end
end

# == Schema Information
#
# Table name: states
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  weight     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :bigint           not null
#
