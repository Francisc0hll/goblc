$('document').ready(function() {

  function timeOutHandler() {
    window.location.href = '/'
  }

  function createTimeout() {
    // 1 minutes
    return window.setTimeout(timeOutHandler, 1000 * 60 )
  }

  var logoutTimeout = createTimeout();

  document.getElementsByTagName('html')[0].addEventListener('click', function() {
    window.clearTimeout(logoutTimeout);
    logoutTimeout = createTimeout();
  });

});
