FactoryBot.define do
  factory :campsite_plan do
    campsite
    name { "c-campsite-001-campsite-plan-1" }
    description { "<h2 data-v-310a20bd=\"\">雲海を見下ろす高原キャンプ場！近隣には温泉も！</h2>\r\n\r\n<p>雲海 を見下ろすほどの高さに位置しながら、関西圏から2～3時間の好アクセス。<br />\r\nキャンプ場から1kmほどの場所には天然温泉施設があり、初心者でも安心です。<br />\r\n全面フリーサイト制ですので、場所を選ぶところからキャンプをお楽しみいただけま<br />\r\nす！</p>\r\n" }
    max_number_of_people { 10 }
    people_type { nil }
    public_info { true }
    publication_period { "" }
    check_in_time { "2000-01-01T02:57:00.000Z" }
    check_out_time { "2000-01-01T02:57:00.000Z" }
    tag_list { ["campsite-plancampsite-plan-1, ccampsite-00c-campsite-001"] }
  end
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
