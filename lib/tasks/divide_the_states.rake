task divide_the_states: :environment do
  # https://app.clickup.com/t/1qeevtt
  ############################
  # Hokkaido - Tohoku (北海道・東北)
  state = Master::State.find_by(name: "北海道・東北")

  if state.present?
    hokkaido = Master::State.create(name: "北海道", code: 'hokkaido')
    hokkaido_prefecture = state.prefectures.find_by(name: "北海道")
    hokkaido_prefecture.update_column(:state_id, hokkaido.id)

    hokkaido_prefectures_cities = Master::City.where(prefecture_id: hokkaido_prefecture.id)
    campsites = Campsite.where(city_id: hokkaido_prefectures_cities.ids)

    campsites.update_all(state_id: hokkaido.id)
    state.update_columns(name: "東北", code: 'tohoku')
  end

  ############################
  # Chugoku - Shikoku (中国・四国)
  state = Master::State.find_by(name: "中国・四国")

  if state.present?
    chugoku = Master::State.create(name: "中国", code: 'chugoku')
    chugoku_prefectures = state.prefectures.where(name: ['岡山', '広島', '鳥取', '島根', '山口'])
    chugoku_prefectures.update_all(state_id: chugoku.id)

    tottori_prefecture = Master::Prefecture.find_by_name('鳥取')
    # Update cities for tottori prefecture
    if tottori_prefecture.present?
      tottori_prefecture.cities.destroy_all
      Master::City.find_or_create_by(name: '鳥取・岩美', prefecture: tottori_prefecture)
      Master::City.find_or_create_by(name: '倉吉・三朝・湯梨浜', prefecture: tottori_prefecture)
      Master::City.find_or_create_by(name: '米子・皆生・大山', prefecture: tottori_prefecture)
    end

    chugoku_prefectures_cities = Master::City.where(prefecture_id: chugoku_prefectures.ids)
    chugoku_campsites = Campsite.where(city_id: chugoku_prefectures_cities.ids)

    chugoku_campsites.update_all(state_id: chugoku.id)
    state.update_columns(name: "四国", code: 'shikoku')
  end

end