$ ->
  $body = $('body')
  $('#container2')
    .on 'mouseenter', '.box', (e)->
      $(this).addClass 'hover'
      $body.addClass 'box_hover'
    .on 'mouseleave', '.box', (e)->
      $(this).removeClass 'hover'
      $body.removeClass 'box_hover'

