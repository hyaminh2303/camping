class ImportNameEnToExistingDataOfAreas < ActiveRecord::Migration[6.1]
  def change
    states_data = JSON.parse(File.read(Rails.root.join('db/data/camp_area_state_en.json'))) # Read data from json file

    states_data.each do |state_data|
      state_existing = Master::State.find_by(code: state_data['code'])
      next if state_existing.blank?

      if state_data['name_en'].present?
        state_existing.name_en = state_data['name_en']
        state_existing.save(validate: false)
      end

      state_data['prefectures'].each do |prefecture_data|
        prefecture_existing = Master::Prefecture.find_by(code: prefecture_data['code'], state: state_existing)
        next if prefecture_existing.blank?

        if prefecture_data['name_en'].present?
          prefecture_existing.name_en = prefecture_data['name_en']
          prefecture_existing.save(validate: false)
        end

        prefecture_data['cities'].each do |city_data|
          city_existing = Master::City.find_by(code: city_data['code'], prefecture: prefecture_existing)
          next if city_existing.blank?

          if city_data['name_en'].present?
            city_existing.name_en = city_data['name_en']
            city_existing.save(validate: false)
          end
        end
      end
    end
  end
end
