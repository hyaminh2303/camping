class CampCarDetail {
  constructor(){
  }

  bindEvents() {
    this.initSlider()
    this.handleBookingTimeRange()
    // Avoid to missing session
    this.handleBookingPrice({success: (resp) => {
      this.getRemainingCampCarQuantity()
    }})
  }

  handleBookingTimeRange() {
    const currentStartDate = $('.camp-car-detail-container-wrapper .start-date-of-renting-input').val()
    const currentEndDate = $('.camp-car-detail-container-wrapper .end-date-of-renting-input').val()

    this.updateTextAndValueForTimeRange(moment(currentStartDate, 'DD/MM/YYYY').format('DD/MM/YYYY'),
      moment(currentEndDate, 'DD/MM/YYYY').format('DD/MM/YYYY'))

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

      this.updateTextAndValueForTimeRange(startDate, endDate)
      this.handleBookingPrice({success: (resp) => {
        this.getRemainingCampCarQuantity()
      }})
    })
  }

  updateTextAndValueForTimeRange(startDate, endDate) {
    $('#camp-car-booking-time-range .start-date-of-renting').text(startDate)
    $('.camp-car-detail-container-wrapper .start-date-of-renting-input').val(startDate)
    $('#camp-car-booking-time-range .end-date-of-renting').text(endDate)
    $('.camp-car-detail-container-wrapper .end-date-of-renting-input').val(endDate)
  }

  handleBookingPrice({success = (resp) => {}, error = (err) => {}}) {
    let inputData = $('.camp-car-detail-container-wrapper .camp-car-booking-form').serialize()

    $.ajax({
      url: Routes.calculate_price_camp_cars_path(),
      type: 'post',
      dataType: 'json',
      data: inputData,
      success: (resp) => {
        $('.camp-car-detail-container-wrapper .total-price').text(resp['total_price'])
        $('.camp-car-detail-container-wrapper .number-of-days').text(resp['camp_car_booking']['number_of_nights'])

        success(resp)
      },
      error: (err) => {
        error(err)
      }
    })
  }

  initSlider() {
    $('.slider').slick({
      nextArrow: "",
      prevArrow: "",
      dots: true,
      autoplay: true,
      autoplaySpeed: 1200,
      speed: 1000,
      slidesToShow: 1,
      slidesToScroll: 1,
      centerMode: true,
      arrows: true,
      variableWidth: true,
      centerPadding: '160px',
      responsive: [
        {
          breakpoint: 1600,
          settings: {
            centerPadding: '120px',
          }
        },
        {
          breakpoint: 1400,
          settings: {
            centerPadding: '220px',
          }
        },
        {
          breakpoint: 1200,
          settings: {
            centerPadding: '100px',
          }
        },
        {
          breakpoint: 768,
          settings: {
            centerPadding: '0px'
          }
        }
      ]
    });

    $(".main-slider").slick({
      // Display 2 centered images at the same time
      slidesToShow: 2,
      slidesToScroll: 2,
      autoplay: true,
      dots: true,
      nextArrow: "",
      prevArrow: "",
      autoplaySpeed: 3000,
      speed: 1500
    });

  }

  getRemainingCampCarQuantity() {
    const campCarId = $('.camp-car-detail-container-wrapper #travel_package_camp_car_booking_attributes_camp_car_id').val()
    const checkIn = $('.camp-car-detail-container-wrapper .start-date-of-renting-input').val()
    const checkOut = $('.camp-car-detail-container-wrapper .end-date-of-renting-input').val()

    $.ajax({
      url: Routes.check_remaining_quantity_camp_cars_path(),
      type: 'post',
      dataType: 'json',
      data: {
        camp_car_id: campCarId,
        check_in: checkIn,
        check_out: checkOut
      },
      success: (resp) => {
        if (resp['is_camp_car_out_of_stock']) {
          $('.camp-car-detail-container-wrapper .btn-yellow').addClass('d-none')
        }
        else {
          $('.camp-car-detail-container-wrapper .btn-yellow').removeClass('d-none')
        }
      }
    })
  }
}

export default CampCarDetail
