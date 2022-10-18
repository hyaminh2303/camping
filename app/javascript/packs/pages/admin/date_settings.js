class DateSettings {
  constructor() {
  }

  bindEvents() {
    $('.date-setting-container-wrapper .datepicker').datepicker({
      format: 'yyyy/mm/dd'
    })

    $('.date-setting-container-wrapper .date-setting-form').each((index, e) => {
      const color = $(e).data('color')
      $(e).closest('td').css('background-color', color)
    })

    $('.classification-day-setting-id-input').on('change', (e) => {
      const $actionButtons = $(e.target).closest('.form-inputs').find('.action-buttons')
      $actionButtons.removeClass('d-none')
    })

    $('.date-setting-form .btn-save-date-setting').on('click', (e) => {
      $(e.target).closest('.date-setting-form').submit()
    })

    $('.create-or-update-date-setting-form #bulk_day_of_the_week_selection').on('click', (e) => {
      $('.create-or-update-date-setting-form .day-name').prop('checked', $(e.target).is(":checked"))
    })
  }
}

export default DateSettings
