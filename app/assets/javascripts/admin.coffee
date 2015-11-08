ready = ->

  # ==========================================================================
  #
  #  ++ contens nav ++
  #
  # ==========================================================================

  # -- + add class + -------------
  current = location.pathname.split('/admin/')[1].split('/')[0]
  $("li.#{current}").addClass('current')

  # ==========================================================================
  #
  #  ++ posts new ++
  #
  # ==========================================================================

  # -- + tab UI + -------------
  $('.sticker').each ->
    $(this).children('.form-parts').first().addClass('is-open').show()
  $('.tab').on 'click', ->
    event.preventDefault()
    names = ['link','upload']
    target = $(this).text()
    $(this).nextAll(".#{target}").first().toggleClass('is-open').show()
    names.splice(names.indexOf(target), 1)[0]
    hide = names[0]
    $(this).nextAll(".#{hide}").first().hide()
    $(this).text(hide)
  
  # -- + form submitter + -------------
  $('#new_post > i').on 'click', ->
    event.preventDefault()
    form = $(this).parent('form')
    form.submit()

  # -- + seed url setter + -------------
  $('form').on 'click', '#seed_url.btn.unset', ->
    event.preventDefault()
    setSeed $(this)
  $('form').on 'click', '#seed_url.btn.set', ->
    event.preventDefault()
    resetBtnize $(this), setSeed

  setSeed = (btn) ->
    textBox = btn.siblings('input[type="text"]')
    url     = textBox.val()

    if isUrl url
      $.ajax({url: url, async: true, dataType: 'html',
      success: (res) ->
        console.log 'success!'
        html = $.parseHTML(res)
        title = ''
        $.each html, (i, val) ->
          if $(val)[0].tagName is 'TITLE'
            title = $(val).text()
            false
        textBox.val(title).attr(disabled: true).css({
          borderBottom: '1px solid transparent',
          color: '#bbb',
          fontSize: 14,
          textAlign: 'center'
        })
        btn.text('設定をリセット').toggleClass('unset').toggleClass('set')
      error: ->
        alert 'error'
      })
    else
      # target = e.parent('.form-parts')
      errorEffect textBox

  # -- + image src setter + -------------
  $('form').on 'focusout', '#post_image_src', ->
    event.preventDefault()
    setImageSrcQuote($(this))
  
  setImageSrcQuote = (e) ->
    url = e.val()

    if isUrl url
      $.ajax({url: url, async: true, dataType: 'html',
      success: (res) ->
        console.log 'success!'
        imgTag = e.parents('.image').children('img')
        imgTag.fadeOut 300, ->
          imgTag.attr({src: url})
        imgTag.fadeIn 300, 'easeInQuad'
      error: ->
        target = e.parent('.form-parts')
        errorEffect target
      })
    else
      target = e.parent('.form-parts')
      errorEffect target
  
  # -- + utils + -------------
  isUrl = (url) ->
    url_ck_reg = /^http[a-z]?\:\/\//
    url_ck_reg.test url

  resetBtnize = (btn, func) ->
    btn.text('設定').on('click', func).toggleClass('unset').toggleClass('set')
    btn.siblings('input[type="text"]').val('').attr(disabled: false).css({
      borderBottom: '1px solid #555',
      color: '#555',
      fontSize: 12,
      textAlign: 'left'
    }).focus()
    if func is setImageSrc
      btn.parents('ul').find('li .tab-link').each ->
        $(this).css({display: 'inline-block', color: '#eee'})
      btn.siblings('input[type="text"]').css({color: '#eee'})

  errorEffect = (target) ->
    orgColor = target.css('color')
    target.stop().css {
      backgroundColor: 'rgba(235,25,25,0.9)',
      color: '#eee'
    }
    setTimeout ->
      target.animate {
        backgroundColor: 'rgba(34,34,34,0.2)',
        color: orgColor
      }, 200, 'linear'
    , 2000

$(document).ready(ready)
$(document).on('page:load', ready)