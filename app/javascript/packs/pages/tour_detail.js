class TourDetail {
  constructor() {
  }

  initSlider() {
    $('.main-slider').slick({
      nextArrow: "",
      prevArrow: "",
      dots: true,
      autoplay: true,
      autoplaySpeed: 1000,
      speed: 1000,
      slidesToShow: 2,
      slidesToScroll: 2,
      responsive: [
        {
          breakpoint: 768,
          settings: {
            slidesToShow: 1,
            slidesToScroll: 1,
            centerMode: true,
            centerPadding: '50px',
          }
        }
      ]
    });
  }

}


export default TourDetail