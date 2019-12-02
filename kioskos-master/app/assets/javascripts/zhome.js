$('.message a').click(function(){
   $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
});

$('select').select2();

$(document).on('turbolinks:load', function() {
  document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
  }, false);

  if($('.phone').length ){
    $phone = $('.phone');
    $phone.getkeyboard().reveal();
    show_cleaner_input($phone);
  }
  if($('.rut').length && !$('.add-rut').length){
    $rut = $('.rut');
    show_cleaner_input($rut);
    $rut.getkeyboard().reveal();
  }

  $.validator.addMethod("rut", function(value, element) {
    return this.optional(element) || $.Rut.validar(value);
  }, "Este campo debe ser un rut valido.");

  $.keyboard.keyaction.enter = function(base){
    if (base.el.nodeName === "INPUT") {
      base.accept();      // accept the content
      $('form').submit(); // submit form on enter
    } else {
      base.insertText('\r\n'); // textarea
    }
  };

  $('form').validate({
    rules: {
      password: "required",
      password_again: {
        equalTo: "#password"
      }
    }
  })

  $('form').submit(function( event ) {
    if ( $('form').valid() ) {
      $('.loader-overlay').show().css('display', 'flex');
      var data_timeout = $(this).attr('data-timeout');
      if (data_timeout && parseInt(data_timeout) > 0) {
        var data_redirect = $(this).attr('data-redirect');
        setTimeout(function() {
          $('.loader-overlay').hide();
          if (data_redirect && data_redirect != '') {
           window.location.href = data_redirect;
          }
        }, data_timeout);
      }
      return;
    }
    event.preventDefault();
  });

  $('.clean-input').on('click touch',function(){
    var kb = $(this).next('input').getkeyboard();
    kb.$preview.val('');
    kb.findCaretPos();
  });

  $('input:text, input:password').on('click touchstart',function(){
    hide_other_cleaner_input();
    show_cleaner_input($(this));
  });

  function show_cleaner_input(elem){
    elem.prev('.clean-input').addClass('clean-input-current')
  }

  function hide_other_cleaner_input(){
    $('.clean-input').removeClass('clean-input-current')
  }

});

