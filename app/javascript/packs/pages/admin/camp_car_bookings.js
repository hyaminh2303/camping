class CampCarBookings {
  constructor() {

  }

  bindEvents() {
    this.selectBookingDate()
    this.addNote()
  }

  selectBookingDate() {
    const $campCarBookingStartDateOfRenting = $('#travel_package_camp_car_booking_attributes_start_date_of_renting')
    const $campCarBookingEndDateOfRenting = $('#travel_package_camp_car_booking_attributes_end_date_of_renting')

    $('#camp-car-booking-date-range-picker').daterangepicker({
      startDate: moment($campCarBookingStartDateOfRenting.val(), 'DD/MM/YYYY').format('YYYY/MM/DD'),
      endDate: moment($campCarBookingEndDateOfRenting.val(), 'DD/MM/YYYY').format('YYYY/MM/DD'),

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

    $('#camp-car-booking-date-range-picker').on('apply.daterangepicker', (e, picker) => {
      const startDate = picker.startDate.format('DD/MM/YYYY')
      const endDate = picker.endDate.format('DD/MM/YYYY')

      $('#camp-car-booking-date').val(`${startDate} - ${endDate}`)
      $campCarBookingStartDateOfRenting.val(startDate)
      $campCarBookingEndDateOfRenting.val(endDate)

      this.handleBookingPrice({})
    })
  }

  handleBookingPrice({success = (resp) => {}, error = (err) => {}}) {
    const inputData = $('.edit_travel_package').serialize()
    const campCarBookingId = $('.edit_travel_package').data('campCarBookingId')

    $.ajax({
      url: Routes.calculate_price_admin_camp_car_booking_path({id: campCarBookingId}),
      type: 'patch',
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

  addNote() {
    $('.add-note-button').on('click', (e) => {
      const campCarBookingId = $(e.target).data('campCarBookingId')

      $.ajax({
        url: Routes.add_note_form_admin_camp_car_bookings_path(),
        type: 'GET',
        dataType: 'html',
        data: {
          camp_car_booking_id: campCarBookingId
        },
        success: (resp) => {
          $('#commonModal .modal-body').html(resp)
          $('#commonModal').modal()
        }
      })
    })
  }

}

export default CampCarBookings