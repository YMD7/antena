ready = ->
  
  # ==========================================================================
  #
  #  ++ contents nav ++
  #
  # ==========================================================================

  # -- + controll parents + -------------
  $("#contents_nav > ul > li > a").each ->
    $(this).on 'click', ->
      event.preventDefault()
      $(this).next('ul').slideToggle 300, ->
        $(this).prev('a').find('i:last-child')
          .toggleClass('fa-angle-left')
          .toggleClass('fa-angle-down')

  # -- + add current to lists + -------------
  pathname = location.pathname

  parentClass = pathname.split('/admin/')[1].split('/')[0]
  childClass  = pathname.split('/admin/')[1].replace('/', '-')

  $("#contents_nav > ul > li.#{parentClass}").each ->
    $(this).children('ul').css({display: 'block'})
    $(this).children('a').addClass('current').find('i:last-child')
      .toggleClass('fa-angle-left')
      .toggleClass('fa-angle-down')
    $(this).find("ul > li > a.#{childClass}").addClass('current')

  # -- + profile menu + -------------
  $('#user > .icon').on 'click', ->
    $(this).toggleClass('active')
    $(this).next().fadeToggle(100)

  # ==========================================================================
  #
  #  ++ posts new ++
  #
  # ==========================================================================

  # -- + single / talk tab UI + -------------
  $('#draft_contents .row > ul > li').on 'click', ->
    $(this).siblings().removeClass('current')
    $(this).addClass('current')

    postType = $(this).attr('class').split(' ')[0]
    target   = $("#draft_contents .row .inner.#{postType}")
    target.siblings('.inner').addClass('hidden')
    target.removeClass('hidden')

  # -- + image src tab UI + -------------
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
        e.val('URLを入力')

        domain = url.match(/^[httpsfile]+:\/{2,3}([0-9a-zA-Z\.\-:]+):?[0-9]*?/i)[1]
        e.parents('.sticker').next('span').text(domain)

        imgTag = e.parents('.image').children('img')
        imgTag.fadeOut 300, ->
          imgTag.attr({src: url})
        imgTag.fadeIn 300, 'easeInQuad'

        postType = getPostType()
        if postType is 'talk'
          target = e.parents('.talk-title').next('.talk-body').find('#title .bg')
          target.fadeOut 300, ->
            target.css({backgroundImage: "url('#{url}')"})
          target.fadeIn 300, 'easeInQuad'

      error: ->
        target = e.parent('.form-parts')
        errorEffect target
      })
    else
      target = e.parent('.form-parts')
      errorEffect target

  # -- + talk title setter + -------------
  $('#draft_contents .inner.talk .talk-title .comment .sentence textarea').on 'focusout', ->
    $('#draft_contents .row .inner.talk .talk-body #title h1').text($(this).text())

  # -- + insert talk elements + -------------
  $('#body .insert-element button').on 'click', ->
    event.preventDefault()
    insertType = $(this).attr('class')

    if insertType is 'speak'
      insertSpeakElement $(this)

    if insertType is 'header'
      insertHeaderElement $(this)

  insertSpeakElement = (btn) ->
    container = btn.parent().prev()
    lastPerson = container.find('div:last-child').attr('class')
    targetPerson = if lastPerson is 'first-person' then 'second-person' else 'first-person'
    el = container.find(".#{targetPerson}").first().clone()
    el.find('textarea').text('テキストを入力')
    el.appendTo(container).hide().fadeIn 300
    
  insertHeaderElement = (btn) ->
    container = btn.parent().prev()
    el = container.find('input').first().clone()
    el.val('見出しを入力').appendTo(container).hide().fadeIn 300
    
  # -- + utils + -------------
  getPostType = ->
    $('#draft_contents .row > ul > li.current').attr('class').split(' ')[0]

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
    orgBgColor = target.css('backgroundColor')
    orgColor   = target.css('color')
    target.stop().css {
      backgroundColor: 'rgba(235,25,25,0.9)',
      color: '#eee'
    }
    setTimeout ->
      target.animate {
        backgroundColor: orgBgColor,
        color: orgColor
      }, 500, 'linear'
    , 800

  # ==========================================================================
  #
  #  ++ users new ++
  #
  # ==========================================================================

  # -- + change email address of preview + -------------
  mailInput = $('#main.new-user #user .inputs > .required .mail input')
  mailInput.on 'focusout', ->
    address = $(this).val()
    if isMailAddress address
      $(this).parents('.inputs').next('.preview').find('.body p.hello .mail').text(address)
    else if address isnt ''
      errorEffect $(this)

  # -- + submit mail + -------------
  $('#main.new-user .bottom-menu').on 'click', ->
    console.log $(this).parent('form').submit()

  # -- + utils + -------------
  isMailAddress = (address) ->
    address_ck_reg = /^[A-Za-z0-9]+[\w-]+@[\w\.-]+\.\w{2,}$/
    address_ck_reg.test address

if location.pathname.match('admin')
  $(document).ready(ready)
  $(document).on('page:load', ready)