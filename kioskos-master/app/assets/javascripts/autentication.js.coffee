Autenticate = () ->
  window.wssocket = new WSSocketConstructor("fvdzWLeXqST8JaOLxjERrA==", recibir);

stopBiometric = () ->
  (window.wssocket).enviar({
    'token': (window.wssocket).token,
    'comando': "finalizar_transaccion"})

window.retry = () ->
  if window.wssocket.estaAbierto()
    stopBiometric
    window.wssocket.cerrar()
  (window.wssocket).conectar()
  setTimeout (->
    window.startTransaction()
    return
  ), 1000
  $('#modalErrorMOC').modal('hide')

validate_signature = (data) ->
  $.get('/biometrics/validate_result',
    user_info: data,
    event: 'autenticacion').done (data) ->
      if data[0]['result'] == true
        if data[0]['previus']
          window.location.href = data[0]['previus']
        else
          window.location.href = '/clave_unicas/alternatives'
      else
        $('#modalErrorAuth').modal('show')
      return

window.startTransaction = () ->
  (window.wssocket).enviar({
    'token': (window.wssocket).token,
    'comando': "iniciar_transaccion"})
  return

window.onerror = (errorMsg, url, lineNumber) ->
  if errorMsg.indexOf("wssocket: Socket no está abierto") > -1
    totem = $('body')[0].dataset.totem
    Rollbar.error("MatchOnCard: "+errorMsg, {totem_id: totem});
    $('#modalErrorMOC').modal('show')
    true
  false

recibir = (data) ->
  tipo = data["tipo"]
  respCode = '0'
  console.log data
  totem = $('body')[0].dataset.totem
  if data['codigoError'] != undefined
    errorAction(data['codigoError'])
  else
    switch tipo
      when "ocr_leido"
        $('#huellaBody').addClass( 'hide')
        $('#cedulaBody').removeClass('hide')
      when "autenticacion"
        validate_signature(data)
        stopBiometric

errorAction = (code) =>
  switch code
    when 1000
      $('#modalErrorGeneric').modal('show')
    when 1042
      $('#modalErrorGeneric').modal('show')
    when 1020
      $('#modalErrorTimeOut').modal('show')
    when 1001
      showCIError()
    when 1030
      showCIError()
    when 1040
      $('#modalErrorGeneric').modal('show')
    when 1041
      showHuellaError()
    when 1050
      $('#modalErrorGeneric').modal('show')
    when 1051
      $('#modalErrorCI').modal('show')
    when 1052
      showCIError()
    when 1060
      $('#modalErrorGeneric').modal('show')
    when 1061
      showCIError()
    else
      $('#modalErrorGeneric').modal('show')
  return

showCIError = () ->
  window.ciErrorCount++
  if window.ciErrorCount == 10
    window.ciErrorCount = 0
    $('#modalErrorAuth').modal('show')

showHuellaError = () ->
  window.huellaErrorCount++
  if window.huellaErrorCount == 5
    window.huellaErrorCount = 0
    $('#modalErrorHuella').modal('show')

Autenticate()
(window.wssocket).conectar()

window.matchOnCardError = false

$(document).on 'turbolinks:load', ->
  return if window.location.href.indexOf("biometrics/intro") == -1
  if !window.wssocket.estaAbierto()
    totem = $('body')[0].dataset.totem
    if !window.matchOnCardError
      Rollbar.error("MatchOnCard: Error in connection establishment: net::ERR_CONNECTION_REFUSED", {totem_id: totem});
      window.matchOnCardError = true
    $('#modalErrorConection').modal('show')
    (window.wssocket).conectar()
  return

$(document).on 'turbolinks:load', ->

  $('#claveunica-totem').click (e)->
    if window.wssocket.estaAbierto()
      window.startTransaction()
      window.huellaErrorCount = 0
      window.ciErrorCount = 0
    else
      e.preventDefault()
      totem = $('body')[0].dataset.totem
      if !window.matchOnCardError
        Rollbar.error("MatchOnCard: Error in connection establishment: net::ERR_CONNECTION_REFUSED", {totem_id: totem});
        window.matchOnCardError = true
      $('#modalErrorConection').modal('show')
      (window.wssocket).conectar()
    return

  $(document).on 'click touch', '#change-finger', (event) ->
    (window.wssocket).enviar({
    'token': (window.wssocket).token,
    'comando': "cambiar_dedo"})
    return

  $(document).on 'click touch', '#clave_unica', () ->
    stopBiometric
    return

  $(document).on 'click touch', '#retry-button', (event) ->
    window.retry()
    return

  $(document).on 'click touch', '#back', (event) ->
    window.location.href = '/'
    return

  return

