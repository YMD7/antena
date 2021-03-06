ready = ->
  
  # ==========================================================================
  #
  #  ++ top ++
  #
  # ==========================================================================

  # --------------------------------
  #                     + lazy load +
  # --------------------------------
  $('img.lazy').lazyload({
    threshold: 10,
    effect: "fadeIn",
    effect_speed: 1000
  })

  # --------------------------------
  #                     + inview +
  # --------------------------------
  $('.loader').bind 'inview', (isInView) ->
    rows = $('#posts').children('.hidden')
    c = rows.length
    if c > 0
      i = 0
      rows.each ->
        $(this).fadeIn(1300).removeClass('hidden')

        c--
        if i++ is 4 then false
    else
      $('.loader').unbind 'inview'
      for hidden in [
        $('#company'),
        $('#company .map'),
        $('.to-top'),
        $('footer')
      ]
        hidden.removeClass('hidden')

if location.pathname is '/'
  $(document).ready(ready)
  $(document).on('page:load', ready)