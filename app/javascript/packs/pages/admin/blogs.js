class Blogs {
  constructor() {
  }

  bindEvents() {
    $('.remove-img').on('click', (e) => {
      $('#blog_photo_attributes__destroy').prop('disabled', false)
      $('.image-wrapper, .invalid-feedback').addClass('d-none')
    })
  }
}

export default Blogs