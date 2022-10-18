import { ajax } from "jquery"

class Campsite {
  constructor() {

  }

  bindEvents() {
    $('.bank-card-header').on('click', (e) => {
      const $bankCardBody = $(e.target).closest('.card').find('.bank-card-body')
      $bankCardBody.slideToggle()
    })

    $('.admin-campsite-form .supplier-company-input').on('change', (e) => {
      const supplierCompanyId = $(e.target).val()

      this.reloadChildAndPetEntranceFeesForm(supplierCompanyId)
    })
  }

  reloadChildAndPetEntranceFeesForm(supplierCompanyId) {
    const campsiteId = $(".admin-campsite-form").data("campsite-id")

    $.ajax({
      url: Routes.reload_child_and_pet_entrance_fees_form_admin_campsites_path(),
      type: 'post',
      dataType: 'html',
      data: {
        supplier_company_id: supplierCompanyId,
        campsite_id: campsiteId
      },
      success: (resp) => {
        const $newChildAndPetEntranceFeesForm = $($.parseHTML(resp)).find("#child-and-pet-entrance-fees-form-reload")
        $('#child-and-pet-entrance-fees-form').html($newChildAndPetEntranceFeesForm)
      },
      error: (err) => {
        error(err)
      }
    })
  }
}

export default Campsite