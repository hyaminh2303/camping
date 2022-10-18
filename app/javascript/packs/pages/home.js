class Home {
  constructor(){
  }

  initSlider() {
    const autoplay_speed = 1500;
    const speed = 1500;

    $('.main-slider').slick({
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      fade: true,
      autoplay: true,
      autoplaySpeed: autoplay_speed,
      speed: speed,
      asNavFor: '.secondary-slider',
      cssEase: 'linear',
    });

    $('.secondary-slider').slick({
      nextArrow: "",
      prevArrow: "",
      dots: true,
      autoplay: true,
      autoplaySpeed: autoplay_speed,
      speed: speed,
      slidesToShow: 4,
      slidesToScroll: 1,
      centerMode: true,
      centerPadding: '160px',
      arrows: true,
      variableWidth: true,
      asNavFor: '.main-slider',
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
            slidesToShow: 3,
            centerPadding: '220px',
          }
        },
        {
          breakpoint: 1200,
          settings: {
            slidesToShow: 2,
            centerPadding: '100px',
          }
        },
        {
          breakpoint: 768,
          settings: {
            slidesToShow: 1,
            centerPadding: '0px'
          }
        }
      ]
    });

  }
}

export default Home
