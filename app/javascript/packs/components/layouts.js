class Layout {
  constructor(){
  }

  bindEvents() {
    $('.btn-open-left-sidebar, .btn-close-left-sidebar').on('click', () => {
      this.toggleLeftSideBar()
    })

    $(document).on('input', 'input[type="number"]', (e) => {
      const currentVal = Number($(e.target).val())
      const minVal = Number($(e.target).attr('min'))
      const maxVal = Number($(e.target).attr('max'))

      if (currentVal < minVal) {
        $(e.target).val('')
      }

      if (currentVal > maxVal) {
        $(e.target).val(maxVal)
      }
    })

    this.bindTabsButton()
    this.bindShowMoreButton()

    $('.bootstrap-datepicker').datepicker({
      format: 'yyyy/mm/dd'
    })

    $('.select2').select2({
      width: '100%'
    })

    $('.select2-single-selection').select2({
      width: '100%',
      theme: 'bootstrap4'
    })

    $('.daterangepicker').daterangepicker({
      "opens": "center",
      "drops": "auto",
      "autoUpdateInput": false,
      locale: {
        cancelLabel: 'クリア',
        format: 'YYYY/MM/DD',
        separator: '-',
        applyLabel: '適用する',
        daysOfWeek: I18n.t('date.abbr_day_names'),
        monthNames: I18n.t('date.abbr_month_names'),
        firstDay: 1
      },
      cancelButtonClasses: "btn btn-sm btn-gray"

      }, (start, end, label) => {}
    )

    $('.supplier-company-handler').on('change', () => {
      let $selectEl = $('.resource-by-company');
      $selectEl.children('option').remove();

      let options = $('.resource-by-company').data('options');
      let selectedCompany = $('.supplier-company-handler').val();

      $selectEl.append(
        $('<option></option>').attr('value', '').text('')
      );
      $selectEl.val('');

      if (!!options) {
        const optionIds = (options[parseInt(selectedCompany)] || []).map( (option) => {
          return option['id'];
        });

        (options[parseInt(selectedCompany)] || []).forEach( (option) => {
          $selectEl.append(
            $('<option></option>').attr('value', option['id']).text(option['label'])
          );
        })

        if (!!$selectEl.data('selected') && optionIds.indexOf($selectEl.data('selected')) > -1 ) {
          $selectEl.val($selectEl.data('selected'))
        }
      }

      $('.resource-by-company').select2({
        width: '100%',
        theme: 'bootstrap4'
      });

    }).trigger('change')

    $('.bootbox-confirmation').on('click', (e) => {
      bootbox.confirm({
        message: $(e.target).data('confirm') || 'Are you sure?',
        buttons: {
          confirm: {
            label: `<i class="fa fa-check"></i> ${$(e.target).data('confirmButton')}`,
            className: 'btn-success'
          },
          cancel: {
            label: `<i class="fa fa-times"></i> ${$(e.target).data('cancelButton')}`,
            className: 'btn-danger'
          }
        },
        callback: (result) => {
          if (result) {
            const csrfToken = $("meta[name='csrf-token']").attr('content');
            let $form = $(`<form method="post" action="${$(e.target).attr('href')}"></form>`);
            $form.append(`<input type="hidden" name="authenticity_token" value=${csrfToken}>`);
            $form.append(`<input type="hidden" name="_method" value=${$(e.target).data('method')}>`);
            $('body').append($form);
            $form.submit()
          }
        }
      });

      return false;
    })

    $('.help-button').on('click', (e) => {
      this.toggleSearchFreeWordModal(true)
      $('body').addClass('noscroll')
    })

    $('.closebtn').on('click', (e) => {
      this.toggleSearchFreeWordModal(false)
      $('body').removeClass('noscroll')
    })

  }

  toggleLeftSideBar() {
    $('#left-sidebar-menu.sidebar').toggleClass('open')
  }

  bindTabsButton() {
    $('#left-tab-button').on('click', () => {
      this.toggleActiveTabsButton('left', 'right')
    })
    $('#right-tab-button').on('click', () => {
      this.toggleActiveTabsButton('right', 'left')
    })

    if ($('#left-tab-button').hasClass('tab-active')){
      $('#left-tab-button').trigger('click')
    }
    if ($('#right-tab-button').hasClass('tab-active')){
      $('#right-tab-button').trigger('click')
    }

    $('#return-btn').on('click', () => {
      $('#left-tab-button').trigger('click')
    })
  }

  bindShowMoreButton(){
    $('.show-more-wrapper').each((index, showMoreWrapper) => {
      const numberOfItems = parseInt($(showMoreWrapper).data('number-of-items-when-init'))

      $(showMoreWrapper).find('.show-more-item.d-none').slice(0, numberOfItems).removeClass('d-none')

      if (!$(showMoreWrapper).find('.show-more-item.d-none').length) {
        $(showMoreWrapper).find('.show-more-button').addClass('d-none')
      }
    })

    $('.show-more-wrapper .show-more-button').on('click', (e) => {
      const $showMoreWrapper = $(e.target).closest('.show-more-wrapper')
      let items = $showMoreWrapper.find('.show-more-item.d-none')

      if (!!$showMoreWrapper.data('number-of-items-when-show')) {
        const numberOfItems = parseInt($showMoreWrapper.data('number-of-items-when-show'))
        items = items.slice(0, numberOfItems)
      }

      items.removeClass('d-none')
      items.css({ 'transition' : 'opacity 1s ease', 'opacity' : '0', 'height' : ''})
      items.css({ 'opacity' : ''})

      if (!$showMoreWrapper.find('.show-more-item.d-none').length) {
        $(e.target).addClass('d-none')
      }
    })
  }

  toggleActiveTabsButton(position, inverse_position) {
    $(`#${position}-tab-button`).addClass('tab-active')
    $(`#${position}-tab-content`).removeClass('d-none')

    if (position == 'left') {
      $('.list-title').removeClass('d-none')
      $('.info-title').addClass('d-none')
    }
    else {
      $('.info-title').removeClass('d-none')
      $('.list-title').addClass('d-none')
    }

    $(`#${inverse_position}-tab-button`).removeClass('tab-active')
    $(`#${inverse_position}-tab-content`).addClass('d-none')
  }

  toggleSearchFreeWordModal(value) {
    if (value) {
      $('#searchFreeWordModal').height('100%')
    } else {
      $('#searchFreeWordModal').height('0%')
    }
  }

}

export default Layout
