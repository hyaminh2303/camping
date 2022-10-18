class CampsiteBookings {
  constructor() {

  }

  bindEvents() {
    this.selectBookingDate()
    this.updateBookingPriceOnInputChange()
    this.addNote()
    this.getRemainingCampsitePlanQuantity()
  }

  selectBookingDate() {
    const $campsiteBookingCheckInt = $('#travel_package_campsite_booking_attributes_check_in')
    const $campsiteBookingCheckOut = $('#travel_package_campsite_booking_attributes_check_out')

    $('#campsite-booking-date-range-picker').daterangepicker({
      startDate: moment($campsiteBookingCheckInt.val(), 'YYYY/MM/DD').format('YYYY/MM/DD'),
      endDate: moment($campsiteBookingCheckOut.val(), 'YYYY/MM/DD').format('YYYY/MM/DD'),
      minDate: moment().add(1, 'day').format('YYYY/MM/DD'),

      locale: {
        cancelLabel: 'クリア',
        format: 'YYYY/MM/DD',
        separator: '-',
        applyLabel: '適用する',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      }
    })

    $('#campsite-booking-date-range-picker').on('apply.daterangepicker', (e, picker) => {
      const startDate = picker.startDate.format('YYYY/MM/DD')
      const endDate = picker.endDate.format('YYYY/MM/DD')

      $('#campsite-booking-date').val(`${startDate} - ${endDate}`)
      $campsiteBookingCheckInt.val(startDate)
      $campsiteBookingCheckOut.val(endDate)

      this.handleBookingPrice({})
      this.getRemainingCampsitePlanQuantity()

    })
  }

  handleBookingPrice({success = (resp) => {}, error = (resp) => {}}) {
    let params = {}
    let inputData = ''
    let methodType = 'post'

    if ($('.admin-campsite-booking-wrapper .new_travel_package').length) {
      inputData = $('.admin-campsite-booking-wrapper .new_travel_package').serialize()
      params['is_new_campsite_booking'] = 'true'
    } else if ($('.admin-campsite-booking-wrapper .edit_travel_package').length) {
      inputData = $('.admin-campsite-booking-wrapper .edit_travel_package').serialize()
      params['campsite_booking_id'] = $('.admin-campsite-booking-wrapper .edit_travel_package').data('campsiteBookingId')
      methodType = 'patch'
    }

    $.ajax({
      url: Routes.calculate_price_admin_campsite_bookings_path(params),
      type: methodType,
      dataType: 'json',
      data: inputData,
      success: (resp) => {
        $('#total-price').val(resp['total_price'])

        success(resp)
      },
      error: (err) => {
        error(err)
      }
    })
  }

  updateBookingPriceOnInputChange() {
    $('.admin-campsite-booking-wrapper .recalculate-price-on-change').on ('change', () => {
      this.handleBookingPrice({})
      this.getRemainingCampsitePlanQuantity()
    })
  }

  addNote() {
    $('.add-note-button').on('click', (e) => {
      const campsiteBookingId = $(e.target).data('campsiteBookingId')

      $.ajax({
        url: Routes.add_note_form_admin_campsite_bookings_path(),
        type: 'GET',
        dataType: 'html',
        data: {
          campsite_booking_id: campsiteBookingId
        },
        success: (resp) => {
          $('#commonModal .modal-body').html(resp)
          $('#commonModal').modal()
        }
      })
    })
  }

  getRemainingCampsitePlanQuantity() {
    const campsitePlanId = $('.admin-campsite-booking-wrapper #travel_package_campsite_booking_attributes_campsite_plan_id').val()
    const checkIn = $('.admin-campsite-booking-wrapper #travel_package_campsite_booking_attributes_check_in').val()
    const checkOut = $('.admin-campsite-booking-wrapper #travel_package_campsite_booking_attributes_check_out').val()
    const travelPackageId = $('.admin-campsite-booking-wrapper #travel_package_id').val()

    if ($('#travel-package-form-wrapper').length) {
      $.ajax({
        url: Routes.check_remaining_quantity_admin_campsite_bookings_path(),
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
            $('.admin-campsite-booking-wrapper .submit-button').prop('disabled', true)
          }
          else {
            $('.admin-campsite-booking-wrapper .submit-button').prop('disabled', false)
          }
        }
      })
    }
  }

}

export default CampsiteBookings