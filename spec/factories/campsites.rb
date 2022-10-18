FactoryBot.define do
  factory :campsite do
    unique_id { "campsite-002" }
    name { "相模湖休養村キャンプ場" }
    address { "神奈川県相模原市相模湖町寸沢嵐3574" }
    contact_number { "0312151215" }
    state_id { 1 }
    prefecture_id { 2 }
    city_id { 16 }
    created_at { "2021-09-30T02:43:39.827Z" }
    updated_at { "2021-09-30T03:39:03.443Z" }
    supplier_company_id { 2 }
    description { "\\u003cp\\u003e\\u003cstrong\\u003e深い緑に囲まれ居心地の良い場内は、都心から1時間ちょっとと}は思えないほど豊かな自然が残っています。いつもと違う休日をぜひ過ごしにきてください。深い緑に囲まれ居心地の良い場内は、都心から1時間ちょっととは思えないほど豊かな自然が残っています。いつもと違う休日をぜひ過ごしにきてください。深い緑に囲まれ居心地の良い場内は、都心から1時間ちょっととは思えないほど豊かな自然が残っています。いつもと違う休日をぜひ過ごしにきてください。\\u003c/strong\\u003e\\u003c/p\\u003e\\r\\n" }
    basic_fee { "120000.0" }
    extra_person_fee { "13000.0" }
    number_of_people_pet_included { 5 }
    city
    state
    prefecture
    after(:build) do |instance|
      supplier_company = build(:supplier_company, type: 'CampsiteSupplierCompany')
      instance.supplier_company = supplier_company
      instance.campsite_supplier_company = supplier_company.becomes(CampsiteSupplierCompany)
    end
  end
end

# == Schema Information
#
# Table name: campsites
#
#  id                            :bigint           not null, primary key
#  about_cancellation            :text
#  address                       :string
#  attachment                    :string
#  basic_fee                     :integer
#  business_information          :text
#  contact_number                :string
#  description                   :text
#  email_address                 :string
#  extra_person_fee              :integer
#  facilities_equipment          :text
#  fax                           :string
#  keep_private                  :boolean          default(FALSE)
#  latitude                      :float
#  longitude                     :float
#  name                          :string
#  number_of_people_pet_included :integer
#  peripheral_facilities         :text
#  post_code                     :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  city_id                       :bigint
#  prefecture_id                 :bigint
#  state_id                      :bigint
#  supplier_company_id           :integer
#  unique_id                     :string
#
# Indexes
#
#  index_campsites_on_city_id        (city_id)
#  index_campsites_on_prefecture_id  (prefecture_id)
#  index_campsites_on_state_id       (state_id)
#
