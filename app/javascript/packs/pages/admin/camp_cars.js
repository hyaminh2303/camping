class CampCars {
  constructor() {
  }

  bindEvents() {
    $('#camp_car_supplier_company_id').on('change', () => {
      let $selectEl = $('#camp_car_option_ids_input');
      $selectEl.children('option').remove();

      let options = $('#camp_car_option_ids_input').data('options');
      let selectedCompany = $('#camp_car_supplier_company_id').val();

      (options[parseInt(selectedCompany)] || []).forEach( (option) => {
        $selectEl.append(
          $('<option></option>').attr('value', option['id']).text(option['label'])
        );
      })
    })

    $('#camp-car-quantities').on('cocoon:after-insert', (e, insertedItem, originalEvent) => {
      $(insertedItem).find('.bootstrap-datepicker').datepicker({
        format: 'dd/mm/yyyy'
      });
    });
  }
}

export default CampCars
