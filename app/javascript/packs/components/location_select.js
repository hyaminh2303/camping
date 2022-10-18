class LocationSelect {
  constructor() {
  }

  bindEvents() {
    $('#state-input').on('change', (e) => {
      const prefectures = $(e.target).find('option:selected').data('prefectures')

      this.deleteOptionsForPrefectureInput()
      this.deleteOptionsForCityInput()
      this.addOptionsForPrefectureInput(prefectures)
    }).trigger('change')

    $('#prefecture-input').on('change', (e) => {
      const prefectures = $('#state-input').find('option:selected').data('prefectures')
      const prefecture = !!prefectures ? prefectures[e.target.value] : {}
      const cities = !!prefecture ? prefecture.cities : {}

      this.deleteOptionsForCityInput()
      this.addOptionsForCityInput(cities)
    })

    this.setLocationSelectedValue()

    $('#state-input, #prefecture-input, #city-input').select2({
      width: '100%',
      theme: 'bootstrap4'
    })
  }

  setLocationSelectedValue() {
    $('#prefecture-input').val($('#prefecture-input').data('current-value')).trigger('change')
    $('#city-input').val($('#city-input').data('current-value'))
  }

  addOptionsForPrefectureInput(prefectures) {
    for (let prefecture_id in prefectures) {
      $('#prefecture-input').append(new Option(prefectures[prefecture_id].name, prefecture_id))
    }
  }

  addOptionsForCityInput(cities) {
    for (let city_id in cities) {
      $('#city-input').append(new Option(cities[city_id].name, city_id))
    }
  }

  deleteOptionsForPrefectureInput() {
    $('#prefecture-input').find('option:not(:first)').remove()
  }

  deleteOptionsForCityInput() {
    $('#city-input').find('option:not(:first)').remove()
  }
}

export default LocationSelect
