require "test_helper"

class CampsitePlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: campsite_plans
#
#  id                       :bigint           not null, primary key
#  check_in_time            :time
#  check_out_time           :time
#  description              :text
#  is_included_entrance_fee :boolean          default(TRUE)
#  max_number_of_people     :integer
#  name                     :string
#  people_type              :integer
#  public_info              :boolean
#  publication_period       :string
#  quantity                 :integer
#  subtitle                 :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campsite_id              :integer
#  campsite_plan_id         :bigint           not null
#
