ready = ->

  # ==========================================================================
  #
  #  ++ post ++
  #
  # ==========================================================================

  # -- + set title height + -------------
  wH = window.innerHeight                 # window height
  hH = $('header').height()               # header height
  mP = $('#main.post').css('padding-top') # main padding-top
  tH = wH - hH - parseInt(mP)             # title height
  
  $('#title').height(tH)

$(document).ready(ready)
$(document).on('page:load', ready)