define ['queue_item', 'color_handler'], (QueueItem, ColoHandler)->
  class Queue
    constructor: (element)->
      @$el           = $(element)
      @id            = 0
      @length        = 0
      @$count        = $('#stats').find('.sum span')
      @$deleted      = $('#stats').find('.deleted span')
      @deleted_count = 0

      @_registerHandlers()

      state = @_readState()
      if state
        @id = state.id if state.id
        for item in state.items
          @length += 1
          @$el.append(new QueueItem(item).template)
      else
        @length += 1
        @id += 1
        @$el.append(new QueueItem({id: @id}).template)
      @_update()

      @$el.trigger 'loaded.queue'

    _registerHandlers: ->
      @$el.on 'click', '.box', @_onBoxClick
      @$el.on 'click', '.delete', @_onBoxDeleteClick

    _onBoxClick: (e)=>
      @length += 1
      @id += 1
      $(e.currentTarget).after(new QueueItem({id:@id}).template)
      @_update()

    _onBoxDeleteClick: (e)=>
      e.stopPropagation()
      e.preventDefault()
      return unless @length > 1

      $box = $(e.currentTarget).closest('.box')
      return unless confirm("Delete box with id #{$box.find('h1').text()}?")
      $box.remove()
      @length -= 1
      @deleted_count += 1

      @_update()

    _update: ->
      @_updateRows()
      @_updateStats()
      @_updateContainerColor()
      @_updateState()

    _updateContainerColor: ->
      color = ColoHandler.calculateInitialColor(@length)
      @$el.css('background-color', color)

    _updateStats: ->
      @$count.text(@$el.find('.box').length)
      @$deleted.text(@deleted_count)

    _updateRows: ->
      @$el.find('.box').each (i, element)=>
        index = i + 1

        $element = $(element)
        $element.removeClass('mod1 mod2 mod3 mod4 third half full highlight')
        $element.find('.prev').text('')
        $element.find('.next').text('')

        #recreate rows
        my_row = @_calculateBoxSize(index)
        $element.addClass(my_row)

        #recreate coloring
        $element.addClass "mod#{index % 4 or 4}"

        #update neighbor ids
        $prev_item = $element.prev()
        if $prev_item and $prev_item.hasClass(my_row)
          prev_id = $prev_item.find('h1').text()
          $element.find('.prev').text(prev_id)

        $next_item = $element.next()
        if $next_item and @_calculateBoxSize(index + 1) is my_row
          next_id = $next_item.find('h1').text()
          $element.find('.next').text(next_id)

      # add higlight class
      @$el.find('.box').last().addClass 'highlight'

    _calculateBoxSize: (index)->
      switch (index % 6)
        when 1,2,3
          my_row = 'third'
        when 4,5
          my_row = 'half'
        when 0
          my_row = 'full'

      return my_row

    _readState: -> JSON.parse localStorage.getItem('boxes_data')

    _updateState: ->
      state =
        id : @id
        items: []

      @$el.find('.box').each (i, element)=>
        $element = $(element)

        state.items.push
          id: $element.find('h1').text()
          prev: $element.find('.prev').text()
          next: $element.find('.next').text()

      localStorage.setItem 'boxes_data', JSON.stringify(state)
      JSON.stringify(JSON.parse(localStorage.getItem('boxes_data')), null, 2)

  return Queue