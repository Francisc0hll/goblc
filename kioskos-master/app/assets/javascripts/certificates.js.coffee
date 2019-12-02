$(document).on 'turbolinks:load', ->
  if $('input[name=quien]:checked').val() == 'self'
    $('.add-rut').show()
  $('input[name=quien]').change ->
     $('input[type="text"]').val('')
  # $('.add-rut').focusout ->
  #   $('.rut').getkeyboard().close()
