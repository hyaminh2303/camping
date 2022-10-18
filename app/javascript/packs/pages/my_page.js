import { ajax } from "jquery"

class MyPage {
  constructor(){

  }

  bindEvents() {
    this.handleUrlParams()
    this.handleShowDetailMessages()
  }

  handleUrlParams() {
    $('#right-tab-button').on('click', () => {
      let params = new URLSearchParams(window.location.search)
      params.append('is_updating_profile', true)

      let my_page_url = `${window.location.pathname}?${params}`

      window.history.replaceState(null, null, my_page_url)
    })

  }

  handleShowDetailMessages() {
    $(".comment-detail-button").on("click", (e) => {
      const url = $(e.target).attr("href");
      $.ajax({
        url: url,
        dataType: "html",
        type: "GET",
        success: (resp) => {
          $("#detailMessageModal .modal-content").html(resp);
          $("#detailMessageModal").modal("show");
        }
      })
      return false;
    })
  }
}

export default MyPage
