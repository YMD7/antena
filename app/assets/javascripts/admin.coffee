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

  # -- + autosize textareas + -------------
  # http://www.jacklmoore.com/autosize/
  autosize($('#main.posts-new #contents_field textarea'))

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
  $('#new_post > div.bottom-menu > ul > li').on 'click', 'a.confirm', ->
    event.preventDefault()
    $('#new_post').submit()

  # -- + seed url form selecter + -------------
  $('form').on 'focus', 'input#post_seed_title', ->
    $(this).select()

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
  $('form').on 'focus', '#post_image_src', ->
    $(this).select()

  # $('form').on 'focusout', '#post_image_src', ->
  #   event.preventDefault()
  #   setImageSrcQuote($(this))
  
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

  # --------------------------------
  #                     + talk +
  # --------------------------------

  # -- + toggle user search box + -------------
  $('#draft_contents .inner.talk .talk-title .icons').on 'click', '.icon', ->
    index = $(this).parents('.icons').children('.icon').index(this)
    $('#user_search').removeClass('hidden').fadeTo(400, 1).addClass("#{index}")
  $('#user_search > div > div.tools > div.close-icon > a > i').on 'click', ->
    $('#user_search').fadeTo(400, 0).attr(class: '')
    setTimeout ->
      $('#user_search').addClass('hidden')
    , 400

  # -- + user searching + -------------
  USER_SEARCH_WORDS = $('#user_search .search-box').find('input').val()
  $('#user_search .search-box').on 'keyup', 'input', ->
    key = $(this).val().toLowerCase()
    if USER_SEARCH_WORDS isnt key
      USER_SEARCH_WORDS = $(this).val()
      ids = getUserIdsByKey key
      lists  = $('#user_search .results ul li')
      displaySearchResult ids, lists

  getUserIdsByKey = (key) ->
    ids = []
    $('#user_search .results ul li').each (i) ->
      img = $(this).children('img')
      id  = img.attr('user_id')
      for num in id.split('')
        if ///#{key}///.exec num then ids.push id; return true;
      for term in img.attr('title').split(' ')
        if ///#{key}///.exec term.toLowerCase() then ids.push id; return true;
      for term in img.attr('user_name_jp').split(' ')
        if ///#{key}///.exec term.toLowerCase() then ids.push id; return true;
      for term in img.attr('user_name_en').split(' ')
        if ///#{key}///.exec term.toLowerCase() then ids.push id; return true;
    return ids

  displaySearchResult = (ids, lists) ->
    lists.each ->
      if ids.indexOf($(this).children('img').attr('user_id')) is -1
        $(this).fadeOut 100
      else
        $(this).show()

  # -- + push search icon away + -------------
  $('#user_search .search-box').on 'focus', 'input', ->
    $(this).css({"background-position": "-20px center";})
  $('#user_search .search-box').on 'focusout', 'input', ->
    moveSearchIcon $(this)

  moveSearchIcon = (e) ->
    if e.val().length is 0
      e.css({"background-position": "4px center";})
    else
      e.css({"background-position": "-20px center";})
  
  # -- + talk title setter + -------------
  $('#post_talk_post_title').on 'focusout', ->
    $('.inner.talk .talk-body #title h1').text($(this).text())

  # -- + cansel if press enter + -------------
  $('.talk-body > #body .talk-body-header').keypress (e) ->
    if e.which is 13 then return false

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
    lastPerson = container.find('div').last().attr('class')
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
  #  ++ users index ++
  #
  # ==========================================================================

  # -- + show user detail + -------------
  $('#users .inner .card > .body').on 'click', '> a.menu-icon.close', ->
    toggleMenuIcon $(this)
    showUserDetail $(this).siblings('.detail')
  # -- + hide user detail + -------------
  $('#users .inner .card > .body').on 'click', '> a.menu-icon.open', ->
    toggleMenuIcon $(this)
    hideUserDetail $(this).siblings('.detail')

  toggleMenuIcon = (menuIcon) ->
    menuIcon.toggleClass('close').toggleClass('open').find('i').toggleClass('fa-chevron-down').toggleClass('fa-chevron-up')    
  showUserDetail = (target) ->
    target.show().animate({opacity: 1; top: 0;}, 500, 'easeOutBounce')
  hideUserDetail = (target) ->
    target.show().animate({opacity: 0; top: '-101%';}, 600, 'easeInOutQuint')

  # ==========================================================================
  #
  #  ++ user new ++
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
    address_ck_reg = /^[A-Za-z0-9\.]+[\w-]+@[\w\.-]+\.\w{2,}$/
    address_ck_reg.test address

if location.pathname.match('admin')
  $(document).ready(ready)
  $(document).on('page:load', ready)