class UpdateWeightOfExistingCities < ActiveRecord::Migration[6.1]
  def change
    Master::Prefecture.includes(:cities).each do |prefecture|
      count = 0
      prefecture.cities.each do |city|
        weight = city.code == 'other' ? prefecture.cities.count : count += 1
        city.update(weight: weight)
      end
    end
  end
end
