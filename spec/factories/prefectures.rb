FactoryBot.define do
  factory :prefecture, class: 'Master::Prefecture' do
    state
    name { 'Thu Duc' }
  end
end

# == Schema Information
#
# Table name: prefectures
#
#  id            :bigint           not null, primary key
#  code          :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#  state_id      :bigint
#
# Indexes
#
#  index_prefectures_on_state_id  (state_id)
#
