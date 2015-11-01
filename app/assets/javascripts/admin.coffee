ready = ->

  # ==========================================================================
  #
  #  ++ posts new ++
  #
  # ==========================================================================

  $('.tab').each (index) ->
    $(this).children('li').first().children('a').addClass('is-active').next().addClass('is-open').show()

  $('.tab').on 'click', 'li > a.tab-link', (event) ->
    if !$(this).hasClass('is-active')
      event.preventDefault()
      accordionTabs = $(this).closest('.tab')
      accordionTabs.find('.is-open').removeClass('is-open').hide()
      $(this).next().toggleClass('is-open').toggle()
      accordionTabs.find('.is-active').removeClass 'is-active'
      $(this).addClass 'is-active'
    else
      event.preventDefault()

  # -- + upload file btn + -------------
  $('#post_image').on 'change', ->
    array = $(this).val().split('\\')
    fileNameText = $('#file_name')
    fileNameText.css({display: 'inline'})
    fileNameText.attr({
      value: array[array.length - 1],
      disabled: true
    })

$(document).ready(ready)
$(document).on('page:load', ready)