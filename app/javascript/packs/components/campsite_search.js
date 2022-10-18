class CampsiteSearch {
  constructor() {

  }

  bindEvents() {
    this.toggleMenuLocationSearch()
    this.handleCampsiteLocationSearch()
    this.handleAdvanceSearch()
    this.setValueForLocationInput()
    this.calendarInput()
    this.facilityTypeInput()
    this.toggleInputSearch()
    this.toggleCampCategories()
    this.handleSyncForm()
    this.handleResetSearch()
  }

  handleAdvanceSearch() {
    $('#advance-search .advance-search-icheck-input').each( (index, e) => {
      const $label = $(e).next()
      const labelText = $label.text()
      $label.remove()
      $(e).iCheck({
        checkboxClass: 'icheckbox_line icheck-default-style',
        insert: labelText,
        checkedClass: 'checked icheck-checked-style'
      });
      $(e).on('ifChanged', (e) => {
        const otherCheckbox = $(`#camp-category-${e.target.value}-md`).get(0)
        otherCheckbox.checked = e.target.checked
      })
    })
  }

  handleSyncForm() {
    $('.form-check-input').on('change', (e) => {
      $(`#camp-category-${e.target.value}-sm`).get(0).checked = e.target.checked
    })
  }

  toggleMenuLocationSearch() {
    const $menu_search = $('.campsite-location-search-wrapper')

    $('.area-input').on('click', (e) => {
      e.stopPropagation()
      $menu_search.slideToggle("fast")
      $('.item-wrapper').removeClass('active')
      $('.prefecture-list, .city-list').addClass('d-none')
      $('.location-list-inner-content').scrollLeft(0)
    })

    $menu_search.on("click", (e) => {
      e.stopPropagation()
    })

    $('.close').on('click', (e) => {
      e.preventDefault()
      $menu_search.hide()
    })

    $(document).on('click', () => {
      $menu_search.hide()
    })
  }

  handleCampsiteLocationSearch() {
    let $state_list_items = $('.state-list .item-wrapper')
    let $prefecture_list_items = $('.prefecture-list .item-wrapper')
    let $city_list_items = $('.city-list .item-wrapper')

    let $current_state_el
    let $current_prefecture_el
    let $current_city_el

    $state_list_items.hover( (e) => {
      $state_list_items.removeClass('active')
      $('.prefecture-list').removeClass('d-none')
      $('.city-list').addClass('d-none')

      let $event_el = $(e.target)
      $current_state_el = $event_el.hasClass('item-wrapper') ?
        $event_el : $event_el.parents('.item-wrapper')

      let stateId = $current_state_el.data('stateId')
      $current_state_el.addClass('active')

      $prefecture_list_items.each ( (index, prefectureEvent) => {
        if (stateId == $(prefectureEvent).data('stateId')) {
          $(prefectureEvent).parents('.location-item').removeClass('d-none')
        } else {
          $(prefectureEvent).parents('.location-item').addClass('d-none')
        }
      })

    },
      (e) => {
        $state_list_items.removeClass('active')
        if ($('.prefecture-list:hover').length) {
          $current_state_el.addClass('active')
        } else {
          $('.prefecture-list, .city-list').addClass('d-none')
        }
      }
    )

    $prefecture_list_items.hover( (e) => {
      $prefecture_list_items.removeClass('active')
      $('.city-list').removeClass('d-none')

      let $event_el = $(e.target)
      $current_prefecture_el = $event_el.hasClass('item-wrapper') ?
        $event_el : $event_el.parents('.item-wrapper')

      $current_prefecture_el.addClass('active')
      $current_state_el.addClass('active')

      let prefectureId = $current_prefecture_el.data('prefectureId')

      $city_list_items.each ( (index, el) => {
        if (prefectureId == $(el).data('prefectureId')) {
          $(el).parents('.location-item ').removeClass('d-none')
        } else {
          $(el).parents('.location-item ').addClass('d-none')
        }
      })
    },
      (e) => {
        $prefecture_list_items.removeClass('active')
        if ($('.city-list:hover').length) {
          $current_prefecture_el.addClass('active')
        } else {
          $('.city-list').addClass('d-none')
        }
      }
    )

    $city_list_items.hover( (e) => {
      $city_list_items.removeClass('active')

      let $event_el = $(e.target)
      $current_city_el = $event_el.hasClass('item-wrapper') ?
        $event_el : $event_el.parents('.item-wrapper')

      $current_state_el.addClass('active')
      $current_prefecture_el.addClass('active')
      $current_city_el.addClass('active')
    },
      (e) => {
        $city_list_items.removeClass('active')
      }
    )

  }

  setValueForLocationInput() {
    $('.location-list .item-wrapper').on('click', (e) => {
      if ($(e.target).hasClass('name') || $(e.target).hasClass('city-item-wrapper')) {
        $('.campsite-location-search-wrapper').hide()
      }

      const $el = $(e.target)

      const $stateIdEl = $el.hasClass('state-item-wrapper') ?
        $el : $el.parents('.state-item-wrapper')
      $('.area-input').text($stateIdEl.data('stateName'))
      $('#state').val($stateIdEl.data('stateId'))

      const $prefectureIdEl = $el.hasClass('prefecture-item-wrapper') ?
        $el : $el.parents('.prefecture-item-wrapper')
      $('.area-input').text($prefectureIdEl.data('prefectureName'))
      $('#prefecture').val($prefectureIdEl.data('prefectureId'))

      const $cityIdEl = $el.hasClass('city-item-wrapper') ?
        $el : $el.parents('.city-item-wrapper')
      $('.area-input').text($cityIdEl.data('cityName'))
      $('#city').val($cityIdEl.data('cityId'))

    })
  }

  calendarInput() {
    $('.group-wrapper-calendar').daterangepicker({
      "opens": "center",
      "drops": "auto",
      "autoUpdateInput": false,
      locale: {
        cancelLabel: I18n.t('daterangepicker.cancelLabel'),
        format: 'YYYY/MM/DD',
        separator: '-',
        applyLabel: I18n.t('daterangepicker.applyLabel'),
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      },
      cancelButtonClasses: "btn btn-sm btn-gray"

      }, (start, end, label) => {}
    )

    if ($('#start_date').val().length > 0 && $('#end_date').val().length > 0) {
      $('.group-wrapper-calendar').data('daterangepicker').setStartDate(moment($('#start_date').val(), 'DD-MM-YYYY'))
      $('.group-wrapper-calendar').data('daterangepicker').setEndDate(moment($('#end_date').val(), 'DD-MM-YYYY'))

      $('.date-box-wrapper').removeClass('d-none')
      $('.input-wrapper').addClass('d-none')
    }
    else {
      $('.date-box-wrapper').addClass('d-none')
      $('.input-wrapper').removeClass('d-none')
    }

    $('.group-wrapper-calendar').on('apply.daterangepicker', (ev, picker) => {
      $('#start_date').val(picker.startDate.format('DD-MM-YYYY'))
      $('#start_date_label').text(picker.startDate.locale(I18n.locale).format(I18n.t('daterangepicker.formats.date_picker')))

      $('#end_date').val(picker.endDate.format('DD-MM-YYYY'))
      $('#end_date_label').text(picker.endDate.locale(I18n.locale).format(I18n.t('daterangepicker.formats.date_picker')))

      $('#staying').text(picker.endDate.diff(picker.startDate, 'day'))

      $('.date-box-wrapper').removeClass('d-none')
      $('.input-wrapper').addClass('d-none')
    })

    $('.group-wrapper-calendar').on('cancel.daterangepicker', (ev, picker) => {
      $('#start_date').val('')
      $('#end_date').val('')
      $('.date-box-wrapper').addClass('d-none')
      $('.input-wrapper').removeClass('d-none')
    })
  }

  facilityTypeInput() {
    $('.allow-focus').on('click', (e) => {
      e.stopPropagation()
    })

    let selectedCampCategories = []

    Object.entries($('.facility-type-input').data('selectedCampCategories')).forEach( ([id, name]) => {
      selectedCampCategories.push({id: id, name: name})

    })

    if ($('.facility-type-input').data('campCategories').length) {
      $('.facility-type-input').data('campCategories').forEach((campCategory, index) => {
        const campCategoriesIds = selectedCampCategories.map(item => item.id)
        const $inputCheckboxEl = $(`input.camp-category-checkbox.c-cate-id-${campCategory.id}`)

        if ( campCategoriesIds.includes($inputCheckboxEl.val()) ) {
          $($inputCheckboxEl).attr('checked', true)
          $($inputCheckboxEl).closest("li").addClass("active")

        }
      })
    }

    $('input.camp-category-checkbox').on('change', (e) => {
      const cCateId = $(e.target).val()
      const campCategoryName = $(e.target).data('cCateName')

      if($(`#camp-category-${cCateId}-sm`).get(0)){
        $(`#camp-category-${cCateId}-sm`).get(0).checked = e.target.checked
      }

      if (e.target.checked) {
        $(`input.camp-category-checkbox.c-cate-id-${cCateId}`).prop('checked', true)
        $(`input.camp-category-checkbox.c-cate-id-${cCateId}`).closest('li').addClass('active')
        selectedCampCategories.push({id: cCateId, name: campCategoryName})
      } else {
        $(`input.camp-category-checkbox.c-cate-id-${cCateId}`).prop('checked', false)
        $(`input.camp-category-checkbox.c-cate-id-${cCateId}`).closest('li').removeClass('active')
        selectedCampCategories.forEach((item, index) => {
          if (cCateId == item.id){
            selectedCampCategories.splice(index, 1)
          }
        })
      }

      this.setCampCategoriesLabel(selectedCampCategories)
    })

    this.setCampCategoriesLabel(selectedCampCategories)
  }

  setCampCategoriesLabel(campCategories) {
    const campCategoriesLabel = campCategories.map(item => item.name).join(', ')
    $('.facility-type-input').text(campCategoriesLabel)
    // put dropdown below parent
    $('.facility-type-selection').css('top', $('.facility-type-input').height() + 15)
  }

  toggleInputSearch() {
    const areaSelectEL = $('.campsite-location-search-wrapper')
    const facilityTypeDropDownEl = $('.facility-type-selection')

    $('.area-input').on('click', () => {
      areaSelectEL.show()
      facilityTypeDropDownEl.hide()
    })

    $('.facility-type-input').on('click', (e) => {
      areaSelectEL.hide()
      facilityTypeDropDownEl.show()
      facilityTypeDropDownEl.addClass('show')
    })

    $(document).on('click', () => {
      areaSelectEL.hide()
      facilityTypeDropDownEl.hide()
    })

  }

  toggleCampCategories(){
    $('.btn-collapse').on("click",(e)=>{
      $(e.currentTarget).children("i").toggleClass("fa-caret-down")
      $(e.currentTarget).children("i").toggleClass("fa-caret-up")
    })
  }

  handleResetSearch(){
    $('.btn-reset-search').on('click', (e) =>{
      $('#advance-search .advance-search-icheck-input').each( (index, e) => {
        $(e).iCheck('uncheck')
      })
    })
  }

}

export default CampsiteSearch
