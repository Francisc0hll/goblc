$(document).on 'turbolinks:load', ->
  cu_modal = document.getElementById('modalErrorCU')
  if cu_modal != null && cu_modal.dataset.show == "true"
    $('#modalErrorCU').modal('show')

  $('.alert-carnet').delay(8000).hide(0);
