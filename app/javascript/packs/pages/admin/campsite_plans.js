class CampsitePlans{
  constructor(){
  }

  bindEvents() {
    $('#campsite-default-fee, #campsite-plan-quantities').on('cocoon:after-insert', (e, insertedItem, originalEvent) => {
      $(insertedItem).find('.datepicker').datepicker({
        format: 'yyyy/mm/dd'
      });
    });

    $('.datepicker').datepicker({
      format: 'yyyy/mm/dd'
    })

    this.toggleHideShowDateType($('#campsite_plan_campsite_plan_fee_attributes_fee_type').val())

    $('#campsite_plan_campsite_plan_fee_attributes_fee_type').on('change', (e) => {
      this.toggleHideShowDateType($(e.target).val())
    })

    if ($('#campsite_plan_campsite_id').length) {
      this.getCamsiteInfo($('#campsite_plan_campsite_id').val())

      if ($(".admin-campsite-plan-form").data('request-method') === 'GET') {
        this.reloadChildAndPetFeesForm($('#campsite_plan_campsite_id').val())
      }
    }

    $('#campsite_plan_campsite_id').on('change', (e) => {
      this.getCamsiteInfo(e.target.value)
      this.reloadChildAndPetFeesForm(e.target.value)
    })

    $('#campsite_plan_campsite_id').on('change', (e) => {
      const campsitePlanOptions = $(e.target).find('option:selected').data('campsitePlanOptions');
      let $campsiteOptionEl = $('#campsite_plan_campsite_plan_option_ids');
      $campsiteOptionEl.children('option').remove();

      (campsitePlanOptions || []).forEach( (option) => {
        let is_checked =  $campsiteOptionEl.data('currentValue').includes(option.id)

        $campsiteOptionEl.append(
          $('<option></option>').attr('value', option['id']).text(option['label']).attr('selected', is_checked)
        );
      })

    })
  }

  toggleHideShowDateType(value) {
    if (value == 'normal'){
      $('.normal-plan-fee-setting').removeClass('d-none')
      $('.normal-plan-fee-setting').find('input').attr('disabled', false);
      $('.classification-day-setting').addClass('d-none')
      $('.classification-day-setting').find('input').attr('disabled', true);
    } else if (value == 'classification_day'){
      $('.normal-plan-fee-setting').addClass('d-none')
      $('.normal-plan-fee-setting').find('input').attr('disabled', true);
      $('.classification-day-setting').removeClass('d-none')
      $('.classification-day-setting').find('input').attr('disabled', false);
    }
  }

  getCamsiteInfo(value) {
    $.ajax({
      url: Routes.camsite_default_fee_admin_campsite_plans_path(),
      type: 'POST',
      dataType: 'JSON',
      data: {
        campsite_id: value
      },
      success: (resp) => {
        $('.defaut-basic-fee').text(resp.basic_fee)
        $('.defaut-number-of-people-pet-included').text(resp.number_of_people_pet_included)
        $('.defaut-extra-person-fee').text(resp.extra_person_fee)
      }
    })
  }

  reloadChildAndPetFeesForm(campsiteId) {
    const campsitePlanId = $(".admin-campsite-plan-form").data('campsite-plan-id')
    const locale = $(".admin-campsite-plan-form").data('locale')

    $.ajax({
      url: Routes.reload_child_and_pet_fees_form_admin_campsite_plans_path(),
      type: 'post',
      dataType: 'html',
      data: {
        campsite_id: campsiteId,
        campsite_plan_id: campsitePlanId,
        locale: locale
      },
      success: (resp) => {
        const $newNormalChildAndpetFeesForm = $($.parseHTML(resp)).find("#normal-child-and-pet-fees-form-reload")
        $("#normal-child-and-pet-fees-form").html($newNormalChildAndpetFeesForm)
        // Reload classification day fees form, includes: classification_day_campsite_plan_fee_details_fields,
        // classification_day_child_and_pet_fees, classification_day_setting_ids
        const $newClassificationDayFees = $($.parseHTML(resp)).find("#classification-day-fees-form-reload")
        $("#classification-day-fees-form").html($newClassificationDayFees)
        // Show campsite default fee for campsite plan after reload classification campsite plan fee details form
        const campsitePlanCampsiteId = $($.parseHTML(resp)).find('#campsite_plan_campsite_id').val()
        if (typeof campsitePlanCampsiteId != 'undefined') {
          this.getCamsiteInfo(campsitePlanCampsiteId)
        }
      },
      error: (err) => {
        error(err)
      }
    })
  }
}

export default CampsitePlans
