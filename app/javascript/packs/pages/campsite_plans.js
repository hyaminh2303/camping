class CampsitePlans{
  constructor(){
  }

  bindEvents() {
    this.handleBookingTimeRange()
    this.handleBookingAmountOfPeople()
    // Avoid to missing session
    this.handleBookingPrice({success: (resp) => {
      this.getRemainingCampsitePlanQuantity()
    }})
  }

  handleBookingTimeRange() {
    const currentStartDate = $('.campsite-plan-detail-container-wrapper .check-in-input').val()
    const currentEndDate = $('.campsite-plan-detail-container-wrapper .check-out-input').val()

    this.updateTextAndValueForTimeRange(moment(currentStartDate,'YYYY/MM/DD').format('YYYY/MM/DD'), moment(currentEndDate,'YYYY/MM/DD').format('YYYY/MM/DD'))

    $('#campsite-booking-time-range').daterangepicker({
      startDate: moment(currentStartDate, 'YYYY/MM/DD').format('YYYY/MM/DD'),
      endDate: moment(currentEndDate, 'YYYY/MM/DD').format('YYYY/MM/DD'),
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
      const startDate = picker.startDate.format('YYYY/MM/DD')
      const endDate = picker.endDate.format('YYYY/MM/DD')

      this.updateTextAndValueForTimeRange(startDate, endDate)
      this.handleBookingPrice({success: (resp) => {
        this.getRemainingCampsitePlanQuantity()
      }})
    })
  }

  updateTextAndValueForTimeRange(startDate, endDate) {
    $('#campsite-booking-time-range .start-date').text(startDate)
    $('#campsite-booking-time-range .end-date').text(endDate)
    $('.campsite-plan-detail-container-wrapper .check-in-input').val(startDate)
    $('.campsite-plan-detail-container-wrapper .check-out-input').val(endDate)
  }

  handleBookingAmountOfPeople() {
    $('#btn-edit-amount-of-people-and-pet, #campsite-booking-amount-of-people-and-pet').on('click', () => {
      const $peopleAndPetSettingInputs = $('.campsite-plan-detail-container-wrapper .people-and-pet-setting-inputs').clone();

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

      $('.campsite-plan-detail-container-wrapper .number-of-adult').text(
        $('.campsite-booking-form .number-of-adult-input').val()
      )

      const $childSettingInputs = $('.campsite-booking-form .people-and-pet-setting-inputs .number-of-child-setting-input')
      $('.campsite-plan-detail-container-wrapper .number-of-children').text(
        lodash.sumBy($childSettingInputs, (childSettingInput) => {
          return Number($(childSettingInput).val())
        })
      )

      const $petSettingInputs = $('.campsite-booking-form .people-and-pet-setting-inputs .number-of-pet-setting-input')
      $('.campsite-plan-detail-container-wrapper .number-of-pet').text(
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

  handleBookingPrice({success = (resp) => {}, error = (err) => {}}) {
    const inputData = $('.campsite-plan-detail-container-wrapper .campsite-booking-form').serialize()

    $.ajax({
      url: Routes.calculate_price_campsite_plans_path(),
      type: 'post',
      dataType: 'json',
      data: inputData,
      success: (resp) => {
        $('.campsite-plan-detail-container-wrapper .total-price').text(resp['total_price'])
        $('.campsite-plan-detail-container-wrapper .number-of-days').text(resp['campsite_booking']['number_of_nights'])

        success(resp)
      },
      error: (err) => {
        error(err)
      }
    })
  }

  getRemainingCampsitePlanQuantity() {
    const campsitePlanId = $('.campsite-plan-detail-container-wrapper #travel_package_campsite_booking_attributes_campsite_plan_id').val()
    const checkIn = $('.campsite-plan-detail-container-wrapper .check-in-input').val()
    const checkOut = $('.campsite-plan-detail-container-wrapper .check-out-input').val()

    $.ajax({
      url: Routes.check_remaining_quantity_campsite_plans_path(),
      type: 'post',
      dataType: 'json',
      data: {
        campsite_plan_id: campsitePlanId,
        check_in: checkIn,
        check_out: checkOut
      },
      success: (resp) => {
        if (resp['is_campsite_plan_out_of_stock']) {
          $('.campsite-plan-detail-container-wrapper .btn-yellow').addClass('d-none')
        }
        else {
          $('.campsite-plan-detail-container-wrapper .btn-yellow').removeClass('d-none')
        }
      }
    })
  }
}

export default CampsitePlans
