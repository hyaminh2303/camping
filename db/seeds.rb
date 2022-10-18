super_admin = AdminUser.find_or_initialize_by(email: "admin@admin.com")
super_admin.password = "12345678"
super_admin.save
super_admin.add_role_super_admin

########################################
# Import camp area state (ALL CAMP AREA STATES WILL BE UPDATED FROM JSON FILE DATA)
# https://app.clickup.com/t/24ppfbf
########################################
# define method to update area name by locale
def update_name_with_locale(area_exist, area_data, attrs_other, area_class)
  locales_without_ja = I18n.available_locales - ['ja']
  area = if area_exist.present?

    attrs = {}
    locales_without_ja.each do |locale| # update name locale for state
      name_locale = "name_#{locale}"
      next if area_exist.send(name_locale) == area_data[name_locale] || area_data[name_locale].blank?
      attrs[name_locale] = area_data[name_locale]
    end
    if attrs.present?
      area_exist.assign_attributes(attrs)
      area_exist.save(validate: false)
      print '1'
    end
    area_exist

  else

    attrs = {}
    I18n.available_locales.each do |locale|
      attrs["name_#{locale}"] = area_data["name_#{locale}"]
    end
    print '0'
    area_class.create(attrs.merge(attrs_other))
  end

  area
end
##

states_data = JSON.parse(File.read(Rails.root.join('db/data/camp_area_state.json'))) # Read data from json file

states_data.each do |state_data|
  state_exist = Master::State.find_by(name: state_data['name_ja'])
  attrs_other = {}
  attrs_other[:code] = state_data['code']

  state = update_name_with_locale(state_exist, state_data, attrs_other, Master::State)

  state_data['prefectures'].each do |prefecture_data|
    prefecture_exist = Master::Prefecture.find_by(name: prefecture_data['name_ja'], state: state)
    attrs_other = {}
    attrs_other[:state] = state

    prefecture = update_name_with_locale(prefecture_exist, prefecture_data, attrs_other, Master::Prefecture)

    prefecture_data['cities'].each do |city_data|
      city_exist = Master::City.find_by(name: city_data['name_ja'], prefecture: prefecture)
      attrs_other = {}
      attrs_other[:prefecture] = prefecture

      update_name_with_locale(city_exist, city_data, attrs_other, Master::City)
    end
  end
end
########################################
########################################

########################################
# Import Country code
########################################
[
  'america',
  'u_a_e_',
  'argentina',
  'yemen',
  'united_kingdom',
  'italy',
  'iraq',
  'iran',
  'india',
  'indonesia',
  'ukraine',
  'egypt',
  'estonia',
  'australia',
  'netherlands',
  'qatar',
  'canada',
  'cambodia',
  'colombia',
  'jamaica',
  'singapore',
  'switzerland',
  'sweden',
  'spain',
  'sri_lanka',
  'slovenia',
  'thailand',
  'czech_republic',
  'germany',
  'turkey',
  'new_zealand',
  'norway',
  'hungary',
  'bangladesh',
  'philippines',
  'finland',
  'brazil',
  'france',
  'bulgaria',
  'viet_nam',
  'peru',
  'belgium',
  'poland',
  'portugal',
  'malaysia',
  'myanmar',
  'mexico',
  'morocco',
  'mongolia',
  'latvia',
  'lithuania',
  'romania',
  'russia',
  'korea',
  'hong_kong_s_a_r_',
  'taiwan',
  'china',
  'south_africa',
  'japan',
  'other'
].each do |code|
  Master::Country.find_or_create_by(code: code)
  print '.'
end
########################################
########################################
