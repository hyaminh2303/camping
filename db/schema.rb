# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_26_112959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountants", force: :cascade do |t|
    t.string "name"
    t.string "name_phonetic"
    t.string "phone_number"
    t.string "email"
    t.bigint "supplier_company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supplier_company_id"], name: "index_accountants_on_supplier_company_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "supplier_company_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admin_users_roles", id: false, force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "role_id"
    t.index ["admin_user_id", "role_id"], name: "index_admin_users_roles_on_admin_user_id_and_role_id"
    t.index ["admin_user_id"], name: "index_admin_users_roles_on_admin_user_id"
    t.index ["role_id"], name: "index_admin_users_roles_on_role_id"
  end

  create_table "app_settings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "campsite_commission_percentage", default: 10.5
    t.integer "publication_fee", default: 5000
    t.float "camp_car_commission_percentage", default: 23.5
  end

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.string "branch_name"
    t.string "account_type"
    t.string "account_number"
    t.string "account_holder"
    t.string "bankable_type"
    t.integer "bankable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_holder_frigana"
  end

  create_table "blog_categories", force: :cascade do |t|
    t.string "icon"
    t.boolean "publish", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "category_type"
    t.integer "weight"
  end

  create_table "blog_category_translations", force: :cascade do |t|
    t.bigint "blog_category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["blog_category_id"], name: "index_blog_category_translations_on_blog_category_id"
    t.index ["locale"], name: "index_blog_category_translations_on_locale"
  end

  create_table "blog_translations", force: :cascade do |t|
    t.bigint "blog_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "description"
    t.text "content"
    t.index ["blog_id"], name: "index_blog_translations_on_blog_id"
    t.index ["locale"], name: "index_blog_translations_on_locale"
  end

  create_table "blogs", force: :cascade do |t|
    t.integer "blog_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "blog_type"
    t.boolean "to_top_page", default: false
    t.boolean "keep_private", default: false
    t.date "publish_date"
  end

  create_table "booking_contact_informations", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.bigint "travel_package_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_code"
    t.date "birthday"
    t.integer "number_of_male"
    t.integer "number_of_female"
    t.index ["travel_package_id"], name: "index_booking_contact_informations_on_travel_package_id"
  end

  create_table "booking_message_details", force: :cascade do |t|
    t.bigint "booking_message_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_message_id"], name: "index_booking_message_details_on_booking_message_id"
    t.index ["owner_type", "owner_id"], name: "index_booking_message_details_on_owner"
  end

  create_table "booking_messages", force: :cascade do |t|
    t.bigint "customer_user_id"
    t.string "subject"
    t.string "booking_messageable_type"
    t.bigint "booking_messageable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_messageable_type", "booking_messageable_id"], name: "index_booking_messages_on_booking_messageable"
    t.index ["customer_user_id"], name: "index_booking_messages_on_customer_user_id"
  end

  create_table "camp_car_bookings", force: :cascade do |t|
    t.datetime "start_date_of_renting"
    t.datetime "end_date_of_renting"
    t.bigint "camp_car_id"
    t.bigint "travel_package_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "supplier_company_id"
    t.text "note"
    t.index ["camp_car_id"], name: "index_camp_car_bookings_on_camp_car_id"
    t.index ["supplier_company_id"], name: "index_camp_car_bookings_on_supplier_company_id"
    t.index ["travel_package_id"], name: "index_camp_car_bookings_on_travel_package_id"
  end

  create_table "camp_car_categories", force: :cascade do |t|
    t.integer "seats"
    t.bigint "pick_up_drop_off_place_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pick_up_drop_off_place_id"], name: "index_camp_car_categories_on_pick_up_drop_off_place_id"
  end

  create_table "camp_car_category_translations", force: :cascade do |t|
    t.bigint "camp_car_category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "model"
    t.index ["camp_car_category_id"], name: "index_camp_car_category_translations_on_camp_car_category_id"
    t.index ["locale"], name: "index_camp_car_category_translations_on_locale"
  end

  create_table "camp_car_option_translations", force: :cascade do |t|
    t.bigint "camp_car_option_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["camp_car_option_id"], name: "index_camp_car_option_translations_on_camp_car_option_id"
    t.index ["locale"], name: "index_camp_car_option_translations_on_locale"
  end

  create_table "camp_car_options", force: :cascade do |t|
    t.integer "fee_per_day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "supplier_company_id"
  end

  create_table "camp_car_options_cars", force: :cascade do |t|
    t.integer "camp_car_id"
    t.integer "camp_car_option_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "camp_car_options_included_in_booking", force: :cascade do |t|
    t.string "name"
    t.integer "fee_per_day"
    t.integer "quantity", default: 0
    t.bigint "camp_car_option_id"
    t.bigint "camp_car_booking_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "camp_car_quantities", force: :cascade do |t|
    t.date "date"
    t.integer "quantity"
    t.bigint "camp_car_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["camp_car_id"], name: "index_camp_car_quantities_on_camp_car_id"
  end

  create_table "camp_car_translations", force: :cascade do |t|
    t.bigint "camp_car_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.text "subtitle"
    t.index ["camp_car_id"], name: "index_camp_car_translations_on_camp_car_id"
    t.index ["locale"], name: "index_camp_car_translations_on_locale"
  end

  create_table "camp_cars", force: :cascade do |t|
    t.string "product_id"
    t.string "car_type"
    t.bigint "category_id"
    t.boolean "is_pick_up_and_drop_off_place_same", default: false
    t.integer "maximum_number_of_people"
    t.boolean "is_public", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "supplier_company_id"
    t.integer "state_id"
    t.integer "prefecture_id"
    t.integer "fee_per_hour"
    t.integer "fee_per_day"
    t.integer "quantity"
    t.index ["category_id"], name: "index_camp_cars_on_category_id"
  end

  create_table "camp_categories", force: :cascade do |t|
    t.bigint "camp_category_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "weight"
    t.index ["camp_category_group_id"], name: "index_camp_categories_on_camp_category_group_id"
  end

  create_table "camp_category_group_translations", force: :cascade do |t|
    t.bigint "camp_category_group_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["camp_category_group_id"], name: "index_bdb2a5875fc0b0c0c7e15b086708281fca3ab0fe"
    t.index ["locale"], name: "index_camp_category_group_translations_on_locale"
  end

  create_table "camp_category_groups", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_facility_type", default: false
    t.boolean "is_the_facility_in_the_hall", default: false
    t.integer "weight"
    t.boolean "is_shown_on_the_front_end", default: true
  end

  create_table "camp_category_translations", force: :cascade do |t|
    t.bigint "camp_category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["camp_category_id"], name: "index_camp_category_translations_on_camp_category_id"
    t.index ["locale"], name: "index_camp_category_translations_on_locale"
  end

  create_table "camp_type_translations", force: :cascade do |t|
    t.bigint "camp_type_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["camp_type_id"], name: "index_camp_type_translations_on_camp_type_id"
    t.index ["locale"], name: "index_camp_type_translations_on_locale"
  end

  create_table "camp_types", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "camp_types_campsites", force: :cascade do |t|
    t.bigint "camp_type_id"
    t.bigint "campsite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["camp_type_id"], name: "index_camp_types_campsites_on_camp_type_id"
    t.index ["campsite_id"], name: "index_camp_types_campsites_on_campsite_id"
  end

  create_table "campsite_bookings", force: :cascade do |t|
    t.integer "number_of_adult"
    t.datetime "check_in"
    t.datetime "check_out"
    t.bigint "travel_package_id"
    t.bigint "campsite_plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "supplier_company_id"
    t.text "note"
    t.index ["campsite_plan_id"], name: "index_campsite_bookings_on_campsite_plan_id"
    t.index ["supplier_company_id"], name: "index_campsite_bookings_on_supplier_company_id"
    t.index ["travel_package_id"], name: "index_campsite_bookings_on_travel_package_id"
  end

  create_table "campsite_camp_categories", force: :cascade do |t|
    t.bigint "campsite_id"
    t.bigint "camp_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["camp_category_id"], name: "index_campsite_camp_categories_on_camp_category_id"
    t.index ["campsite_id"], name: "index_campsite_camp_categories_on_campsite_id"
  end

  create_table "campsite_content_photos", force: :cascade do |t|
    t.bigint "campsite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campsite_id"], name: "index_campsite_content_photos_on_campsite_id"
  end

  create_table "campsite_entrance_fees", force: :cascade do |t|
    t.integer "campsite_id"
    t.integer "adult_fee"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_option_included_in_booking_translations", force: :cascade do |t|
    t.bigint "campsite_option_included_in_booking_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["campsite_option_included_in_booking_id"], name: "index_ab0b5ac02aa5372d5abc967897dc01a5f11da448"
    t.index ["locale"], name: "index_5e0bf2205bcf2f621c4396ec9180891c5b7251a7"
  end

  create_table "campsite_options_included_in_booking", force: :cascade do |t|
    t.integer "price"
    t.integer "quantity", default: 0
    t.bigint "campsite_plan_option_id"
    t.bigint "campsite_booking_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_plan_daily_fee_settings", force: :cascade do |t|
    t.integer "campsite_plan_id"
    t.integer "basic_fee"
    t.integer "number_of_people_pet_included"
    t.integer "extra_person_fee"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_plan_fee_details", force: :cascade do |t|
    t.integer "normal_campsite_plan_fee_id"
    t.integer "basic_fee"
    t.integer "number_of_people_pet_included"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "extra_person_fee"
    t.integer "classification_day_setting_id"
    t.integer "classification_day_campsite_plan_fee_id"
  end

  create_table "campsite_plan_fees", force: :cascade do |t|
    t.integer "campsite_plan_id"
    t.integer "fee_type"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_plan_fees_classification_day_settings", force: :cascade do |t|
    t.integer "campsite_plan_fee_id"
    t.integer "classification_day_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_plan_option_translations", force: :cascade do |t|
    t.bigint "campsite_plan_option_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["campsite_plan_option_id"], name: "index_0a713f21d131b88795000f03d2dd438a010238b0"
    t.index ["locale"], name: "index_campsite_plan_option_translations_on_locale"
  end

  create_table "campsite_plan_options", force: :cascade do |t|
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "campsite_id"
    t.integer "quantity", default: 0
    t.index ["campsite_id"], name: "index_campsite_plan_options_on_campsite_id"
  end

  create_table "campsite_plan_options_plans", force: :cascade do |t|
    t.integer "campsite_plan_id"
    t.integer "campsite_plan_option_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campsite_plan_quantities", force: :cascade do |t|
    t.integer "quantity"
    t.date "date"
    t.bigint "campsite_plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campsite_plan_id"], name: "index_campsite_plan_quantities_on_campsite_plan_id"
  end

  create_table "campsite_plan_translations", force: :cascade do |t|
    t.bigint "campsite_plan_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.text "subtitle"
    t.index ["campsite_plan_id"], name: "index_campsite_plan_translations_on_campsite_plan_id"
    t.index ["locale"], name: "index_campsite_plan_translations_on_locale"
  end

  create_table "campsite_plans", force: :cascade do |t|
    t.integer "campsite_id"
    t.integer "max_number_of_people"
    t.integer "people_type"
    t.boolean "public_info"
    t.string "publication_period"
    t.time "check_in_time"
    t.time "check_out_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity"
    t.boolean "is_included_entrance_fee", default: true
  end

  create_table "campsite_translations", force: :cascade do |t|
    t.bigint "campsite_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "address"
    t.text "business_information"
    t.text "description"
    t.text "about_cancellation"
    t.text "peripheral_facilities"
    t.index ["campsite_id"], name: "index_campsite_translations_on_campsite_id"
    t.index ["locale"], name: "index_campsite_translations_on_locale"
  end

  create_table "campsites", force: :cascade do |t|
    t.string "unique_id"
    t.string "contact_number"
    t.bigint "state_id"
    t.bigint "prefecture_id"
    t.bigint "city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "supplier_company_id"
    t.integer "basic_fee"
    t.integer "extra_person_fee"
    t.integer "number_of_people_pet_included"
    t.text "facilities_equipment"
    t.string "attachment"
    t.float "longitude"
    t.float "latitude"
    t.string "post_code"
    t.boolean "keep_private", default: false
    t.string "fax"
    t.string "email_address"
    t.index ["city_id"], name: "index_campsites_on_city_id"
    t.index ["prefecture_id"], name: "index_campsites_on_prefecture_id"
    t.index ["state_id"], name: "index_campsites_on_state_id"
  end

  create_table "child_and_pet_entrance_fees", force: :cascade do |t|
    t.integer "fee_value", default: 0
    t.bigint "campsite_entrance_fee_id"
    t.bigint "child_and_pet_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campsite_entrance_fee_id"], name: "index_child_and_pet_entrance_fees_on_campsite_entrance_fee_id"
    t.index ["child_and_pet_setting_id"], name: "index_child_and_pet_entrance_fees_on_child_and_pet_setting_id"
  end

  create_table "child_and_pet_fees", force: :cascade do |t|
    t.bigint "normal_campsite_plan_fee_id"
    t.bigint "classification_day_campsite_plan_fee_id"
    t.bigint "classification_day_setting_id"
    t.bigint "child_and_pet_setting_id"
    t.integer "fee_value", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_and_pet_setting_id"], name: "index_child_and_pet_fees_on_child_and_pet_setting_id"
    t.index ["classification_day_setting_id"], name: "index_child_and_pet_fees_on_classification_day_setting_id"
    t.index ["normal_campsite_plan_fee_id"], name: "index_child_and_pet_fees_on_normal_campsite_plan_fee_id"
  end

  create_table "child_and_pet_included_in_booking_translations", force: :cascade do |t|
    t.bigint "child_and_pet_included_in_booking_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "entity_label"
    t.index ["child_and_pet_included_in_booking_id"], name: "index_659fff3f005625d432ff0bc9f112dd08a65973a6"
    t.index ["locale"], name: "index_child_and_pet_included_in_booking_translations_on_locale"
  end

  create_table "child_and_pet_included_in_bookings", force: :cascade do |t|
    t.integer "fee", default: 0
    t.bigint "campsite_booking_id"
    t.string "entity_type"
    t.bigint "child_and_pet_setting_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "child_and_pet_setting_translations", force: :cascade do |t|
    t.bigint "child_and_pet_setting_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "entity_label"
    t.index ["child_and_pet_setting_id"], name: "index_6ad7e39dc8b7c9d56b68731f6a71b4092a2f9fd6"
    t.index ["locale"], name: "index_child_and_pet_setting_translations_on_locale"
  end

  create_table "child_and_pet_settings", force: :cascade do |t|
    t.integer "entity_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "campsite_id"
    t.index ["campsite_id"], name: "index_child_and_pet_settings_on_campsite_id"
  end

  create_table "cities", force: :cascade do |t|
    t.bigint "prefecture_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "weight"
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "city_translations", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["city_id"], name: "index_city_translations_on_city_id"
    t.index ["locale"], name: "index_city_translations_on_locale"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "classification_day_settings", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contact_us", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.text "details_of_inquiry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer "exp_month"
    t.integer "exp_year"
    t.string "last4"
    t.string "card_holder_name"
    t.integer "customer_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customer_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "birthday"
    t.string "phone_number"
    t.string "last_name"
    t.string "first_name"
    t.bigint "country_id"
    t.string "post_code"
    t.string "address"
    t.index ["country_id"], name: "index_customer_users_on_country_id"
    t.index ["email"], name: "index_customer_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customer_users_on_reset_password_token", unique: true
  end

  create_table "date_settings", force: :cascade do |t|
    t.date "date"
    t.bigint "classification_day_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "campsite_id"
    t.index ["campsite_id"], name: "index_date_settings_on_campsite_id"
    t.index ["classification_day_setting_id"], name: "index_date_settings_on_classification_day_setting_id"
  end

  create_table "glover_companies", force: :cascade do |t|
    t.string "company_name"
    t.string "location"
    t.string "phone_number"
    t.string "hp_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gmo_transactions", force: :cascade do |t|
    t.string "order_id"
    t.string "acs"
    t.string "forward"
    t.string "method"
    t.string "pay_times"
    t.string "approve"
    t.string "tran_id"
    t.string "tran_date"
    t.string "check_string"
    t.float "amount"
    t.integer "travel_package_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.string "access_id"
    t.string "access_pass"
  end

  create_table "japanese_public_holidays", force: :cascade do |t|
    t.date "date"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notice_translations", force: :cascade do |t|
    t.bigint "notice_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "content"
    t.index ["locale"], name: "index_notice_translations_on_locale"
    t.index ["notice_id"], name: "index_notice_translations_on_notice_id"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "supplier_company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notice_itemable_type"
    t.bigint "notice_itemable_id"
    t.string "item_type"
    t.date "publish_date"
    t.boolean "keep_private", default: false
    t.index ["notice_itemable_type", "notice_itemable_id"], name: "index_notices_on_notice_itemable"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image"
    t.string "photoable_type"
    t.bigint "photoable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "on_click_url"
    t.index ["photoable_type", "photoable_id"], name: "index_photos_on_photoable"
  end

  create_table "prefecture_translations", force: :cascade do |t|
    t.bigint "prefecture_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["locale"], name: "index_prefecture_translations_on_locale"
    t.index ["prefecture_id"], name: "index_prefecture_translations_on_prefecture_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.bigint "state_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.index ["state_id"], name: "index_prefectures_on_state_id"
  end

  create_table "recommended_camp_items", force: :cascade do |t|
    t.bigint "supplier_company_id"
    t.string "recommended_itemable_type"
    t.bigint "recommended_itemable_id"
    t.integer "weight"
    t.string "item_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recommended_itemable_type", "recommended_itemable_id"], name: "index_recommended_camp_items_on_recommended_itemable"
    t.index ["supplier_company_id"], name: "index_recommended_camp_items_on_supplier_company_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "slider_banner_locales", force: :cascade do |t|
    t.string "locale"
    t.bigint "slider_banner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slider_banner_id"], name: "index_slider_banner_locales_on_slider_banner_id"
  end

  create_table "slider_banners", force: :cascade do |t|
    t.integer "page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "state_translations", force: :cascade do |t|
    t.bigint "state_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["locale"], name: "index_state_translations_on_locale"
    t.index ["state_id"], name: "index_state_translations_on_state_id"
  end

  create_table "states", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "weight"
  end

  create_table "supplier_companies", force: :cascade do |t|
    t.string "operation_classification"
    t.string "company_name"
    t.string "corporate_name_kana"
    t.string "phone_number"
    t.string "fax"
    t.string "location"
    t.string "hp_url"
    t.string "ryokan"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "contract_type"
    t.string "post_code"
    t.text "note"
    t.boolean "is_reflect_in_sales_management", default: false
    t.date "contract_start_date"
  end

  create_table "supplier_contact_informations", force: :cascade do |t|
    t.string "name_of_person_in_charge"
    t.string "person_in_charge_name_kana"
    t.string "phone_number"
    t.string "fax"
    t.string "email_address"
    t.string "location"
    t.string "accounting_personnel_information"
    t.integer "supplier_company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "supplier_corporate_representative_informations", force: :cascade do |t|
    t.string "name_of_representative"
    t.string "name_of_representative_kana"
    t.string "position"
    t.string "email_address"
    t.integer "supplier_company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "travel_packages", force: :cascade do |t|
    t.string "status"
    t.string "booking_type"
    t.string "payment_method"
    t.decimal "total_price"
    t.bigint "customer_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "canceled_at"
    t.string "canceled_by_type"
    t.bigint "canceled_by_id"
    t.string "booked_by_type"
    t.bigint "booked_by_id"
    t.datetime "credit_card_addition_expired_at"
    t.boolean "is_adding_credit_card_reminder_sent", default: false
    t.string "booking_ref_number"
    t.boolean "is_booking_outside", default: false
    t.index ["booked_by_type", "booked_by_id"], name: "index_travel_packages_on_booked_by"
    t.index ["canceled_by_type", "canceled_by_id"], name: "index_travel_packages_on_canceled_by"
    t.index ["customer_user_id"], name: "index_travel_packages_on_customer_user_id"
  end

  add_foreign_key "taggings", "tags"
end
