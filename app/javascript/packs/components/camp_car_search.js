class CampCarSearch {
  constructor() {

  }

  bindEvents() {
    this.toggleMenuLocationSearch()
    this.handleCampCarLocationSearch()
    this.handleAdvanceSearch()
    this.setValueForLocationInput()
    this.calendarInput()

  }

  handleAdvanceSearch() {
    $('#advance-search .advance-search-icheck-input').each( (index, e) => {
      const $label = $(e).next()
      const labelText = $label.text()
      $label.remove();
      $(e).iCheck({
        checkboxClass: 'icheckbox_line icheck-default-style',
        insert: labelText,
        checkedClass: 'checked icheck-checked-style'
      });
    });
  }

  toggleMenuLocationSearch() {
    const $menu_search = $('.camp-car-location-search-wrapper')

    $('.area-input').on('click', (e) => {
      e.stopPropagation()
      $menu_search.slideToggle("fast")
      $('.item-wrapper').removeClass('active')
      $('.prefecture-list').addClass('d-none')
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

  handleCampCarLocationSearch() {
    let $state_list_items = $('.state-list .item-wrapper')
    let $prefecture_list_items = $('.prefecture-list .item-wrapper')

    let $current_state_el
    let $current_prefecture_el

    $state_list_items.hover( (e) => {
      $state_list_items.removeClass('active')
      $('.prefecture-list').removeClass('d-none')

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
          $('.prefecture-list').addClass('d-none')
        }
      }
    )

    $prefecture_list_items.hover( (e) => {
      $prefecture_list_items.removeClass('active')

      let $event_el = $(e.target)
      $current_prefecture_el = $event_el.hasClass('item-wrapper') ?
        $event_el : $event_el.parents('.item-wrapper')

      $current_state_el.addClass('active')
      $current_prefecture_el.addClass('active')

    },
      (e) => {
        $prefecture_list_items.removeClass('active')
      }
    )

  }

  setValueForLocationInput() {
    $('.location-list .item-wrapper').on('click', (e) => {
      if ($(e.target).hasClass('name') || $(e.target).hasClass('prefecture-item-wrapper')) {
        $('.camp-car-location-search-wrapper').hide()
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

    })
  }

  // For the single datepicker
  // calendarInput() {
  //   $(document).on('click', (e) => {
  //     const $startDateEl = $('#start_date_input')
  //     const $endDateEl = $('#end_date_input')
  //     let $selectedStartDateEl = $('#start_date_input .selected-start-date')
  //     let $selectedEndDateEl = $('#end_date_input .selected-end-date')

  //     // get, set for start date
  //     if ($(e.target).hasClass('s-date') || $(e.target).hasClass('selected-start-date')){
  //       $startDateEl.datepicker({
  //         format: 'dd/mm/yyyy'
  //       })

  //       if ($selectedStartDateEl.text().length) {
  //         $startDateEl.datepicker('setDate', $selectedStartDateEl.text())
  //       } else {
  //         $startDateEl.datepicker('setDate', moment().format('DD-MM-YYYY'))
  //       }

  //     } else if ( $('#start_date_input .datepicker').length ){
  //       $('#start_date_input .datepicker').hide()
  //       const startDate = moment($startDateEl.datepicker('getDate')).format('DD-MM-YYYY')
  //       $('#start_date').val(startDate)
  //       $selectedStartDateEl.text(startDate)
  //     }

  //     // get, set for end date
  //     if (($(e.target).hasClass('e-date') || $(e.target).hasClass('selected-end-date')) && $selectedStartDateEl.text().length){
  //       $endDateEl.datepicker({
  //         format: 'dd/mm/yyyy'
  //       })

  //       const is_start_date_after_end_date = moment($selectedStartDateEl.text(), 'DD-MM-YYYY').diff(moment($selectedEndDateEl.text(), 'DD-MM-YYYY'), 'days') > 0

  //       if ($selectedStartDateEl.text().length && is_start_date_after_end_date) {
  //         $endDateEl.datepicker('setStartDate', $selectedStartDateEl.text())
  //         $endDateEl.datepicker('setDate', $selectedStartDateEl.text())
  //       } else if ($selectedStartDateEl.text().length && !$selectedEndDateEl.text().length) {
  //         $endDateEl.datepicker('setStartDate', $selectedStartDateEl.text())
  //         $endDateEl.datepicker('setDate', moment().format('DD-MM-YYYY'))
  //       } else if ($selectedEndDateEl.text().length) {
  //         $endDateEl.datepicker('setStartDate', $selectedStartDateEl.text())
  //         $endDateEl.datepicker('setDate', $selectedEndDateEl.text())
  //       } else {
  //         $endDateEl.datepicker('setDate', moment().format('DD-MM-YYYY'))
  //       }
  //     } else if ($('#end_date_input .datepicker').length) {
  //       $('#end_date_input .datepicker').hide()
  //       const endDate = moment($endDateEl.datepicker('getDate')).format('DD-MM-YYYY')
  //       $('#end_date').val(endDate)
  //       $selectedEndDateEl.text(endDate)
  //     }

  //   })

  // }

  calendarInput() {
    const $date_range_picker_input_el = $('.date-range-wrapper')

    $date_range_picker_input_el.daterangepicker({
      "opens": "center",
      "drops": "auto",
      "autoUpdateInput": false,
      locale: {
        cancelLabel: 'クリア',
        format: 'YYYY/MM/DD',
        separator: '-',
        applyLabel: '適用する',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      },
      cancelButtonClasses: "btn btn-sm btn-gray"

      }, (start, end, label) => {}
    )

    if ($('#start_date').val().length > 0 && $('#end_date').val().length > 0) {
      $date_range_picker_input_el.data('daterangepicker').setStartDate(moment($('#start_date').val(), 'DD-MM-YYYY'))
      $date_range_picker_input_el.data('daterangepicker').setEndDate(moment($('#end_date').val(), 'DD-MM-YYYY'))

      $('.date-box-wrapper').removeClass('d-none')
      $('.input-wrapper').addClass('d-none')
    }
    else {
      $('.date-box-wrapper').addClass('d-none')
      $('.input-wrapper').removeClass('d-none')
    }

    $date_range_picker_input_el.on('apply.daterangepicker', (ev, picker) => {
      $('#start_date').val(picker.startDate.format('DD-MM-YYYY'))
      $('#start_date_label').text(picker.startDate.locale('ja').format('MM/DD(dd)'))

      $('#end_date').val(picker.endDate.format('DD-MM-YYYY'))
      $('#end_date_label').text(picker.endDate.locale('ja').format('MM/DD(dd)'))

      $('#staying').text(picker.endDate.diff(picker.startDate, 'day'))

      $('.date-box-wrapper').removeClass('d-none')
      $('.input-wrapper').addClass('d-none')
    })

    $date_range_picker_input_el.on('cancel.daterangepicker', (ev, picker) => {
      $('#start_date').val('')
      $('#end_date').val('')
      $('.date-box-wrapper').addClass('d-none')
      $('.input-wrapper').removeClass('d-none')
    })
  }

}

export default CampCarSearch
