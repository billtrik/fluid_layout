$ ->
  $body = $('body')
  $body.on 'mouseenter', '.box', (e)->
    $(this).addClass 'hover'
    $body.addClass 'box_hover'

  $body.on 'mouseleave', '.box', (e)->
    $(this).removeClass 'hover'
    $body.removeClass 'box_hover'
