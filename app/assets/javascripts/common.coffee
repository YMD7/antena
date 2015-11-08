ready = ->

  if $('.flash')[0]
      $('.flash').delay(500).animate({opacity: 1.0}, 700, ->
        $('.flash').delay(3000).animate({opacity: 0}, 1000, ->
          $('.flash').css({display: 'none'})
        )
      )

$(document).ready(ready)
$(document).on('page:load', ready)