ready = ->

  unless location.href.match('admin')

    # ==========================================================================
    #
    #  ++ common ++
    #
    # ==========================================================================

    # --------------------------------
    #                     + home link +
    # --------------------------------
    $('#logo').on 'click', ->
      location = document.location
      if location.href is location.origin
        window.location.reload()
      else
        window.location.href = location.origin

    # --------------------------------
    #                     + side menu icon +
    # --------------------------------
    rotateMenuIcon = ->
      state = $('#menu').attr('class')
      if state is 'close'
        $('#menu svg').animate({
          transform: 'rotate(180deg) translate(0,-14px)'
        }, 200)
      else
        $('#menu svg').animate({
          transform: 'rotate(0deg) translate(0)'
        }, 200)

    $('#menu').on 'click', ->
      if window.navigator.userAgent.toLowerCase().indexOf("mobile") isnt -1
        rotateMenuIcon()

    # --------------------------------
    #                     + side menu +
    # --------------------------------
    slide = (e, offset, margin) ->
      console.log 'click'
      state = e.attr('class')
      sideMenu = $('#side_menu')
      if state is 'close'
        sideMenu.animate({
          left: 0,
          marginLeft: margin
        }, 200)
        e.removeClass('close')
        e.addClass('open')
      else
        sideMenu.animate({
          left: offset,
          marginLeft: 0
        }, 500)
        e.removeClass('open')
        e.addClass('close')

    offset = $('#side_menu').css('left')
    $('#menu').on 'click', ->
      windowSize      = $(window).width()
      desktopMaxWidth = 1300

      if windowSize > desktopMaxWidth
        margin = (windowSize - desktopMaxWidth) / 2
      else
        margin = 0
      # margin = $('#first_image').css('marginLeft').replace('px', '')
      if window.navigator.userAgent.toLowerCase().indexOf("mobile") isnt -1
        margin = '2%'
      else if margin < 30
        margin = 30
      slide $(this), offset, margin

    # --------------------------------
    #                     + flash +
    # --------------------------------
    if $('.flash')[0]
        $('.flash').delay(500).animate({opacity: 1.0}, 700, ->
          $('.flash').delay(3000).animate({opacity: 0}, 1000, ->
            $('.flash').css({display: 'none'})
          )
        )

$(document).ready(ready)
$(document).on('page:load', ready)