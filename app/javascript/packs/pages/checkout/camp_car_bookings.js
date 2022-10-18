class CampCarBookings {
  constructor() {

  }

  bindEvents() {
    // this.handleStartDateOfRenting()
    // this.handleEndDateOfRenting()
    this.handleBookingTimeRange()
    this.handleBookingOptionSetting()
    this.getRemainingCampCarQuantity()
  }

  handleBookingTimeRange() {
    const currentStartDate = $('.camp-car-booking-information-wrapper .start-date-of-renting-input').val()
    const currentEndDate = $('.camp-car-booking-information-wrapper .end-date-of-renting-input').val()

    $('#camp-car-booking-time-range').daterangepicker({
      startDate: moment(currentStartDate, 'DD/MM/YYYY').format('YYYY/MM/DD'),
      minDate: moment().format('YYYY/MM/DD'),
      endDate: moment(currentEndDate, 'DD/MM/YYYY').format('YYYY/MM/DD'),
      locale: {
        format: 'YYYY/MM/DD',
        separator: '-',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      }
    })

    $('#btn-edit-camp-car-booking-time-range').on('click', () => {
      $('#camp-car-booking-time-range').trigger('click')
    })

    $('#camp-car-booking-time-range').on('apply.daterangepicker', (e, picker) => {
      const startDate = picker.startDate.format('DD/MM/YYYY')
      const endDate = picker.endDate.format('DD/MM/YYYY')

      $('#camp-car-booking-time-range .start-date-of-renting').text(startDate)
      $('#camp-car-booking-time-range .end-date-of-renting').text(endDate)
      $('.camp-car-booking-information-wrapper .start-date-of-renting-input').val(startDate)
      $('.camp-car-booking-information-wrapper .end-date-of-renting-input').val(endDate)

      this.handleBookingPrice({})
      this.getRemainingCampCarQuantity()
    })
  }

  // handleStartDateOfRenting() {
  //   $('.camp-car-booking-form .start-date-of-renting-input').datepicker({
  //     format: 'dd/mm/yyyy',
  //     container: '#camp-car-booking-start-date-of-renting'
  //   })

  //   $(document).on(
  //     'click',
  //     '#btn-edit-camp-car-booking-start-date-of-renting, #camp-car-booking-start-date-of-renting',
  //     () => {
  //       $('.start-date-of-renting-input').datepicker('show')
  //       this.setOffsetForDatepickerToContainer()
  //     }
  //   )

  //   $('.camp-car-booking-form .start-date-of-renting-input').on('change', (e) => {
  //     $('#camp-car-booking-start-date-of-renting').text($(e.target).val())
  //     this.handleBookingPrice({})
  //   })
  // }

  // handleEndDateOfRenting() {
  //   $('.camp-car-booking-form .end-date-of-renting-input').datepicker({
  //     format: 'dd/mm/yyyy',
  //     container: '#camp-car-booking-end-date-of-renting'
  //   })

  //   $(document).on(
  //     'click',
  //     '#btn-edit-camp-car-booking-end-date-of-renting, #camp-car-booking-end-date-of-renting',
  //     () => {
  //       $('.end-date-of-renting-input').datepicker('show')
  //       this.setOffsetForDatepickerToContainer()
  //     }
  //   )

  //   $('.camp-car-booking-form .end-date-of-renting-input').on('change', (e) => {
  //     $('#camp-car-booking-end-date-of-renting').text($(e.target).val())
  //     this.handleBookingPrice({})
  //   })
  // }

  handleBookingOptionSetting() {
    $('.camp-car-booking-information-wrapper .addition-quantity-btn').on('click', (e) => {
      const $optionIncludedInBookingInput = $(e.target).closest('.option-included-in-booking-input')
      const $optionQuantityInput = $optionIncludedInBookingInput.find('.option-quantity-input')
      const nextNumberOfQuantity = Number($optionQuantityInput.val()) + 1

      $optionQuantityInput.val(nextNumberOfQuantity)
      $optionIncludedInBookingInput.find('.number-of-option-quantity').text(nextNumberOfQuantity)

      this.handleBookingPrice({})
    })

    $('.camp-car-booking-information-wrapper .subtraction-quantity-btn').on('click', (e) => {
      const $optionIncludedInBookingInput = $(e.target).closest('.option-included-in-booking-input')
      const $optionQuantityInput = $optionIncludedInBookingInput.find('.option-quantity-input')
      const nextNumberOfQuantity = Number($optionQuantityInput.val()) - 1

      if (nextNumberOfQuantity >= 0) {
        $optionQuantityInput.val(nextNumberOfQuantity)
        $optionIncludedInBookingInput.find('.number-of-option-quantity').text(nextNumberOfQuantity)

        this.handleBookingPrice({})
      }
    })
  }

  handleBookingPrice({success = (resp) => {}, error = (err) => {}}) {
    let inputData = ''
    let params = {}

    if ($('.camp-car-booking-information-wrapper .new-camp-car-booking-form').length) {
      params['is_new_camp_car_booking'] = 'true'
      inputData =  $('.camp-car-booking-information-wrapper .new-camp-car-booking-form').serialize()
    } else if ($('.camp-car-booking-information-wrapper .camp-car-booking-form').length) {
      inputData = $('.camp-car-booking-information-wrapper .camp-car-booking-form').serialize()
    }

    $.ajax({
      url: Routes.calculate_price_checkout_camp_car_bookings_path(params),
      type: 'post',
      dataType: 'json',
      data: inputData,
      success: (resp) => {
        $('.camp-car-booking-information-wrapper .total-price').text(resp['total_price'])
        $('.camp-car-booking-information-wrapper .number-of-days').text(resp['camp_car_booking']['number_of_nights'])

        success(resp)
      },
      error: (err) => {
        error(err)
      }
    })
  }

  getRemainingCampCarQuantity() {
    const campCarId = $('.camp-car-booking-information-wrapper #travel_package_camp_car_booking_attributes_camp_car_id').val()
    const checkIn = $('.camp-car-booking-information-wrapper .start-date-of-renting-input').val()
    const checkOut = $('.camp-car-booking-information-wrapper .end-date-of-renting-input').val()
    const travelPackageId = $('.camp-car-booking-information-wrapper #travel_package_customer_user_id').val()

    if ($('body').data('action') != 'thank_you') {
      $.ajax({
        url: Routes.check_remaining_quantity_checkout_camp_car_bookings_path(),
        type: 'post',
        dataType: 'json',
        data: {
          camp_car_id: campCarId,
          check_in: checkIn,
          check_out: checkOut,
          travel_package_id: travelPackageId
        },
        success: (resp) => {
          if (resp['is_camp_car_out_of_stock']) {
            $('.camp-car-booking-information-wrapper .btn-yellow').addClass('d-none')
          }
          else {
            $('.camp-car-booking-information-wrapper .btn-yellow').removeClass('d-none')
          }
        }
      })
    }
  }

  // setOffsetForDatepickerToContainer() {
  //   let parentOffset = $('.camp-car-booking-information-wrapper .datepicker').parent().offset()
  //   parentOffset["top"] = parentOffset["top"] + 25

  //   $('.camp-car-booking-information-wrapper .datepicker').offset(parentOffset)
  // }
}

export default CampCarBookings
