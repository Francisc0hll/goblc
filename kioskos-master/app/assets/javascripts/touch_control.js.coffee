$(document).ready ->
  $('*').on 'touchstart', (event) ->
    # The metatag doesn't work on Chrome 62 mobile, at least.
    # This does, but it stops all multitouch actions
    if event.originalEvent.touches.length > 1
      return false
    return
  return
