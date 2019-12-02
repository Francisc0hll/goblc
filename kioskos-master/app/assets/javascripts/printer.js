
function ws_service_printer(action, params, cb_success, cb_error) {
  var socket = new WebSocket("ws://localhost:3002"); 
  socket.onmessage = function(msg){
    var resp = JSON.parse(msg.data);
    socket.close();
    socket = undefined;
    if (cb_success) {
      cb_success(JSON.parse(resp));
    }
  };
  socket.onerror = function(msg){
    if (cb_error) {
      cb_error('Error en la conexión con el servicio se impresión');
    }
    socket.close();
    socket = undefined;
  };
  var interval = setInterval(function() {
    if (socket &&  (socket.readyState == 1)) {
      clearInterval(interval);
      socket.send(JSON.stringify({action: action, params: params}));
    }
  }, 500);
}

function print(certificate_base64, cb_result) {
  ws_service_printer('print', {certificate_base64: certificate_base64}, function(resp) {
    if (resp.success) {
      if (cb_result) {
        cb_result('Tu certificado ha sido impreso', true);
      }
    } else {
      if (cb_result) {
        cb_result(resp.msg, false);
      }
    }
  }, function(error) {
    if (cb_result) {
      cb_result('La impresora no se encuentra disponible', false);
    }
  });
}

//for print an test page from browser command line
function print_test(cb_result) {
  ws_service_printer('print_test', {}, function(resp) {
    if (cb_result) {
      cb_result(resp.msg, resp.success);
    }
  }, cb_result);
}

//for check the printer status from browser command line
function printer_status(cb_result) {
  ws_service_printer('status', {}, function(resp) {
    if (cb_result) {
      cb_result(resp.msg, resp.success);
    }
  }, cb_result);
}
