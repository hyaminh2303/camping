require "test_helper"

class BlogCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: blog_categories
#
#  id               :bigint           not null, primary key
#  category_type    :string
#  icon             :string
#  name             :string
#  publish          :boolean          default(FALSE)
#  weight           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blog_category_id :bigint           not null
#
