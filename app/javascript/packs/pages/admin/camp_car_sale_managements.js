class CampCarSaleManagements {
  constructor(){
  }

  bindEvents(){
    $('.daterange-input').daterangepicker({
      locale: {
        cancelLabel: 'クリア',
        format: 'YYYY/MM/DD',
        separator: ' - ',
        applyLabel: '適用する',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      },
      startDate: moment($('.camp-car-search-wrapper #start_date').val(), 'YYYY/MM/DD').format('YYYY/MM/DD'),
      endDate: moment($('.camp-car-search-wrapper #end_date').val(), 'YYYY/MM/DD').format('YYYY/MM/DD')
    })
    $('.camp-car-search-wrapper .daterange-input').on('apply.daterangepicker', (e, picker) => {
      this.updateStartDateEndDateParams(picker)
    })
    $('.camp-car-search-wrapper .daterange-input').on('hide.daterangepicker', (e, picker) => {
      this.updateStartDateEndDateParams(picker)
    })

  }

  updateStartDateEndDateParams(picker) {
    const startDate = picker.startDate.format('YYYY/MM/DD')
    const endDate = picker.endDate.format('YYYY/MM/DD')

    $('.camp-car-search-wrapper #start_date').val(startDate)
    $('.camp-car-search-wrapper #end_date').val(endDate)
    $('.camp-car-search-wrapper .daterange-input').text(startDate + ' - ' + endDate)
  }
}

export default CampCarSaleManagements
