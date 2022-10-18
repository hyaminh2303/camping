FactoryBot.define do
  factory :blog_category do
    title { "MyString" }
    icon { "MyString" }
    publish { false }
  end
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
