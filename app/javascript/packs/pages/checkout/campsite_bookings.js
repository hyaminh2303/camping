class CampsiteBookings {
  constructor() {

  }

  bindEvents() {
    this.handleBookingTimeRange()
    this.handleBookingAmountOfPeople()
    this.handleBookingOptionSetting()
    this.getRemainingCampsitePlanQuantity()
  }

  handleBookingTimeRange() {
    const currentStartDate = $('.campsite-booking-information-wrapper .check-in-input').val()
    const currentEndDate = $('.campsite-booking-information-wrapper .check-out-input').val()

    $('#campsite-booking-time-range').daterangepicker({
      startDate: moment(currentStartDate, 'DD/MM/YYYY').format('YYYY/MM/DD'),
      endDate: moment(currentEndDate, 'DD/MM/YYYY').format('YYYY/MM/DD'),
      minDate: moment().add(1, 'day').format('YYYY/MM/DD'),
      locale: {
        cancelLabel: ($('#campsite-booking-time-range').data('cancelLabel') || 'Cancel'),
        applyLabel: ($('#campsite-booking-time-range').data('applyLabel') || 'Apply'),
        format: 'YYYY/MM/DD',
        separator: '-',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      }
    })

    $('#btn-edit-campsite-booking-time-range').on('click', () => {
      $('#campsite-booking-time-range').trigger('click')
    })

    $('#campsite-booking-time-range').on('apply.daterangepicker', (e, picker) => {
      const startDate = picker.startDate.format('DD/MM/YYYY')
      const endDate = picker.endDate.format('DD/MM/YYYY')

      $('#campsite-booking-time-range .start-date').text(startDate)
      $('#campsite-booking-time-range .end-date').text(endDate)
      $('.campsite-booking-information-wrapper .check-in-input').val(startDate)
      $('.campsite-booking-information-wrapper .check-out-input').val(endDate)

      this.handleBookingPrice({})
      this.getRemainingCampsitePlanQuantity()
    })
  }

  handleBookingAmountOfPeople() {
    $('#btn-edit-amount-of-people-and-pet, #campsite-booking-amount-of-people-and-pet').on('click', () => {
      const $peopleAndPetSettingInputs = $('.campsite-booking-information-wrapper .people-and-pet-setting-inputs').clone();

      $('#campsite-booking-amount-of-people-and-pet').popover({
        html: true,
        trigger: 'focus',
        placement: 'auto',
        content: () => {
          return $peopleAndPetSettingInputs
        }
      })

      $('#campsite-booking-amount-of-people-and-pet').popover('show')
    })

    $(document).on('click', '.popover .people-and-pet-setting-inputs .btn-apply', () => {
      $(document).find('.popover .people-and-pet-setting-inputs .people-and-pet-setting-input').map((index, e) => {
        $(`.campsite-booking-form #${$(e).attr('id')}`).val($(e).val())
      })

      $('.campsite-booking-information-wrapper .number-of-adult').text(
        $('.campsite-booking-form .number-of-adult-input').val()
      )

      const $childSettingInputs = $('.campsite-booking-form .people-and-pet-setting-inputs .number-of-child-setting-input')
      $('.campsite-booking-information-wrapper .number-of-children').text(
        lodash.sumBy($childSettingInputs, (childSettingInput) => {
          return Number($(childSettingInput).val())
        })
      )

      const $petSettingInputs = $('.campsite-booking-form .people-and-pet-setting-inputs .number-of-pet-setting-input')
      $('.campsite-booking-information-wrapper .number-of-pet').text(
        lodash.sumBy($petSettingInputs, (petSettingInputs) => {
          return Number($(petSettingInputs).val())
        })
      )

      $('#campsite-booking-amount-of-people-and-pet').popover('dispose');
      this.handleBookingPrice({})
    })

    $(document).on('click', '.people-and-pet-setting-inputs .btn-cancel', () => {
      $('#campsite-booking-amount-of-people-and-pet').popover('dispose')
    });
  }

  handleBookingOptionSetting() {
    $('.campsite-booking-information-wrapper .addition-quantity-btn').on('click', (e) => {
      const $optionIncludedInBookingInput = $(e.target).closest('.option-included-in-booking-input')
      const $optionQuantityInput = $optionIncludedInBookingInput.find('.option-quantity-input')
      const nextNumberOfQuantity = Number($optionQuantityInput.val()) + 1

      $optionQuantityInput.val(nextNumberOfQuantity)
      $optionIncludedInBookingInput.find('.number-of-option-quantity').text(nextNumberOfQuantity)

      this.handleBookingPrice({})
    })

    $('.campsite-booking-information-wrapper .subtraction-quantity-btn').on('click', (e) => {
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

    if ($('.campsite-booking-information-wrapper .new-campsite-booking-form').length) {
      params['is_new_campsite_booking'] = 'true'
      inputData =  $('.campsite-booking-information-wrapper .new-campsite-booking-form').serialize()
    } else if ($('.campsite-booking-information-wrapper .campsite-booking-form').length) {
      inputData = $('.campsite-booking-information-wrapper .campsite-booking-form').serialize()
    }

    $.ajax({
      url: Routes.calculate_price_checkout_campsite_bookings_path(params),
      type: 'post',
      dataType: 'json',
      data: inputData,
      success: (resp) => {
        $('.campsite-booking-information-wrapper .total-price').text(resp['total_price'])
        $('.campsite-booking-information-wrapper .number-of-days').text(resp['campsite_booking']['number_of_nights'])

        appMessages({
          messageType: 'error',
          content: resp['error_messages']
        })

        success(resp)
      },
      error: (err) => {
        error(err)
      }
    })
  }

  getRemainingCampsitePlanQuantity() {
    const campsitePlanId = $('.campsite-booking-information-wrapper #travel_package_campsite_booking_attributes_campsite_plan_id').val()
    const checkIn = $('.campsite-booking-information-wrapper .check-in-input').val()
    const checkOut = $('.campsite-booking-information-wrapper .check-out-input').val()
    const travelPackageId = $('.campsite-booking-information-wrapper #travel_package_id').val()

    if ($('body').data('action') != 'thank_you') {
      $.ajax({
        url: Routes.check_remaining_quantity_checkout_campsite_bookings_path(),
        type: 'post',
        dataType: 'json',
        data: {
          campsite_plan_id: campsitePlanId,
          check_in: checkIn,
          check_out: checkOut,
          travel_package_id: travelPackageId
        },
        success: (resp) => {
          if (resp['is_campsite_plan_out_of_stock']) {
            $('.campsite-booking-information-wrapper .btn-yellow').addClass('d-none')
          }
          else {
            $('.campsite-booking-information-wrapper .btn-yellow').removeClass('d-none')
          }
        }
      })
    }
  }


}

export default CampsiteBookings
