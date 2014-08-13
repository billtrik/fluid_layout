require [
  'jquery'
  'queue'
], ($, Queue)->
  $ ->
    $body = $('body')
    $boxes_container = $('#container2')

    $('.clear_state').on 'click', (e)->
      localStorage.removeItem('boxes_data')
      window.location.reload()

    $boxes_container.on 'loaded.queue', (e)-> $('#loader').hide()

    $boxes_container.on 'mouseenter', '.box', (e)->
      $(this).addClass 'hover'
      $body.addClass 'box_hover'

    $boxes_container.on 'mouseleave', '.box', (e)->
      $(this).removeClass 'hover'
      $body.removeClass 'box_hover'

    new Queue($boxes_container)