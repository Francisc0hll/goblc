$(document).on 'turbolinks:load', ->

  num_styles = {
    container: 'ui-keyboard-num-container',
    buttonDefault: 'ui-keyboard-button-num'
  }
  $('input.phone').keyboard({
      autoAccept: true,
      caretToEnd: true,
      closeByClickEvent: true,
      css: num_styles,
      customLayout: { 'normal' : [ '1 2 3', '4 5 6', '7 8 9', '0 {bksp} {enter}'] },
      display: { 'enter': '<i class="material-icons">check</i>', 'bksp': '<i class="material-icons">backspace</i>' },
      enterNavigation: true,
      language: "es",
      layout: 'custom',
      lockInput: true,
      maxLength : 9,
      noFocus: true,
      position: false,
      usePreview: false,
      visible: true,
      alwaysOpen: true,
      
    })
    .addCaret({
        caretClass : '',
        charAttr   : 'data-character',
        charIndex  : -1,
        offsetX    : 0,
        offsetY    : 0,
        adjustHt   : 0
    });
  $('input.rut').keyboard({
      autoAccept: true,
      caretToEnd: true,
      closeByClickEvent: true,
      css: num_styles,
      customLayout: { 'normal' : [ '1 2 3', '4 5 6', '7 8 9', 'K 0 {bksp} {enter}'] },
      display: { 'enter': '<i class="material-icons">check</i>', 'bksp': '<i class="material-icons">backspace</i>' },
      enterNavigation: true,
      language: "es",
      layout: 'custom',
      lockInput: true,
      maxLength : 9,
      noFocus: true,
      position: false,
      usePreview: false,
     
      
    })
    .addCaret({
        caretClass : '',
        charAttr   : 'data-character',
        charIndex  : -1,
        offsetX    : 0,
        offsetY    : 0,
        adjustHt   : 0
    });
  $('input.text').keyboard(
    {
      display: {
        'bksp'   :  '<i class="material-icons">backspace</i>',
        'enter'  :  '<i class="material-icons">check</i>'
        'normal' : 'ABC',
        'meta1'  : '?123',
        'meta2'  : '#+=',
        's'      : '<i class="material-icons">keyboard_capslock</i>'
      },
      layout: 'custom',
      customLayout: {
        'normal': [
          'q w e r t y u i o p {bksp} ',
          'a s d f g h j k l @ {enter}',
          '{s} z x c v b n m , . {s}',
          '{meta1} {space} {meta1}'
        ],
        'shift': [
          'Q W E R T Y U I O P {bksp}',
          'A S D F G H J K L {enter}',
          '{s} Z X C V B N M ! ? {s}',
          '{meta1} {space} {meta1}'
        ],
        'meta1': [
          '1 2 3 4 5 6 7 8 9 0 {bksp}',
          '- / : ; ( ) \u20ac & @ {enter}',
          '{meta2} . , ? ! \' " {meta2}',
          '{normal} {space} {normal}'
        ],
        'meta2': [
          '[ ] { } # % ^ * + = {bksp}',
          '_ \\ | ~ < > $ \u00a3 \u00a5 {enter}',
          '{meta1} . , ? ! \' " {meta1}',
          '{normal} {space} {normal}'
        ]},
      autoAccept: true,
      caretToEnd: true,
      closeByClickEvent: true,
      css: { buttonAction: 'ui-keyboard-meta'},
      enterNavigation: true,
      language: 'es',
      lockInput: true,
      noFocus: true,
      position: false,
      usePreview: false,
      useWheel: false,
    
      
      hidden : (event, keyboard, el) ->
        $('.mail-keyboard').removeClass('mail-keyboard-with-keyboard')    
      beforeVisible : (event, keyboard, el) ->
        $('.container-fluid.mail-keyboard').addClass('mail-keyboard-with-keyboard')  
    })
    .addCaret({
        caretClass : '',
        charAttr   : 'data-character',
        charIndex  : -1,
        offsetX    : 0,
        offsetY    : 0,
        adjustHt   : 0
    });
