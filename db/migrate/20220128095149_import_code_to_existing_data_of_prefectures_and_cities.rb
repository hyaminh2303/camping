class ImportCodeToExistingDataOfPrefecturesAndCities < ActiveRecord::Migration[6.1]
  def change
    states_data = JSON.parse(File.read(Rails.root.join('db/data/camp_area_state.json'))) # Read data from json file

    states_data.each do |state_data|
      state_existing = Master::State.find_by(code: state_data['code'])

      next if state_existing.blank?

      state_data['prefectures'].each do |prefecture_data|
        prefecture_existing = Master::Prefecture.find_by(name: prefecture_data['name_ja'], state: state_existing)

        next if prefecture_existing.blank?
        prefecture_existing.update(code: prefecture_data['code'])

        prefecture_data['cities'].each do |city_data|
          city_existing = Master::City.find_by(name: city_data['name_ja'], prefecture: prefecture_existing)

          next if city_existing.blank?
          city_existing.update(code:city_data['code'])
        end
      end
    end
  end
end
