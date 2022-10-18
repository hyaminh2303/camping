class CampsiteDetail {
  constructor() {
  }

  bindEvents() {
    this.initSlider()

    $('.nav-tab-item').on('click', (e) => {
      $('.nav-tab-item').removeClass('active')
      $(e.currentTarget).addClass('active')
    })

    $('.look-at-the-sketch-btn').on('click', (e) => {
      const $lightBox = $(e.target).closest('.image-item').find('.light-box')

      this.toggleSearchFreeWordModal(true, $lightBox)
      $('body').addClass('noscroll')
    })

    $('.closebtn').on('click', (e) => {
      const $lightBox = $(e.target).closest('.image-item').find('.light-box')

      this.toggleSearchFreeWordModal(false, $lightBox)
      $('body').removeClass('noscroll')
    })
  }

  toggleSearchFreeWordModal(value, $lightBoxElement) {
    if (value) {
      $lightBoxElement.height('100%')
    } else {
      $lightBoxElement.height('0%')
    }
  }

  initSlider() {
    $('.main-slider').slick({
      nextArrow: "",
      prevArrow: "",
      dots: false,
      autoplay: true,
      autoplaySpeed: 3000,
      speed: 1500,
      slidesToShow: 1,
      slidesToScroll: 1,
      centerMode: true,
      centerPadding: '160px',
      arrows: true,
      focusOnSelect: true,
      responsive: [
        {
          breakpoint: 1600,
          settings: {
            centerPadding: '180px',
          }
        },
        {
          breakpoint: 1400,
          settings: {
            centerPadding: '200px',
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
  }

}


export default CampsiteDetail