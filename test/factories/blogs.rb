FactoryBot.define do
  factory :blog do
    title { "MyString" }
    description { "MyText" }
    image { "MyString" }
    publish { false }
  end
end

# == Schema Information
#
# Table name: blogs
#
#  id               :bigint           not null, primary key
#  blog_type        :string
#  content          :text
#  description      :text
#  keep_private     :boolean          default(FALSE)
#  publish_date     :date
#  title            :string
#  to_top_page      :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blog_category_id :integer
#
