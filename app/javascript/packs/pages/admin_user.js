class AdminUser {
  constructor(){
  }

  bindEvents() {
    $('#admin_user_role').on('change', (e) => {
      let role = $(e.target).val()

      this.toggleShowSupplierCompany(role)
      this.handleSupplierCompanySelection(role)

    }).trigger('change')
  }

  toggleShowSupplierCompany(role){
    if (role == 'super_admin' || role == ''){
      $('.admin_user_supplier_company_id').addClass('d-none')
      $('#admin_user_supplier_company_id').attr('disabled', true)
      $('#admin_user_supplier_company_id').val('')
    } else{
      $('.admin_user_supplier_company_id').removeClass('d-none')
      $('#admin_user_supplier_company_id').attr('disabled', false)
    }
  }

  handleSupplierCompanySelection(role){
    if (role != '') {
      let $selectEl = $('#admin_user_supplier_company_id')
      $selectEl.children('option').remove()
      $selectEl.append($('<option></option>'))

      let roles = $('#admin_user_role').data('roles')

      if (!!roles[`${role}_supplier_companies`]) {
        roles[`${role}_supplier_companies`].forEach( (supplier_company) => {
          $selectEl.append(
            $('<option></option>').attr('value', supplier_company[0]).text(supplier_company[1])
          )
          if ($selectEl.data('supplierCompanyId') == supplier_company[0]) {
            $selectEl.val(supplier_company[0])
          }
        })
      }
    }
  }

}

export default AdminUser