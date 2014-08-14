$ ->
  $body = $('body')
  $body.on 'mouseenter', '.box', (e)->
    $(this).addClass 'hover'
    $body.addClass 'box_hover'

  $body.on 'mouseleave', '.box', (e)->
    $(this).removeClass 'hover'
    $body.removeClass 'box_hover'

App = Ember.Application.create()

App.ApplicationAdapter = DS.LSAdapter.extend
  namespace: 'fluid_layout'

App.Router.map ->
  @resource 'boxes',
    path: '/'

## BOXES
App.BoxesRoute = Ember.Route.extend
  model: ->
    if @store.all('box').get('length') is 0
      App.Box.ID = 1
      @store.createRecord('box',
        id: App.Box.ID
        index: 1
      ).save()
    else
      # Get max box.id
      max_id = 0
      @store.all('box').getEach('id').forEach (id, index, arr)->
        id = parseInt(id, 10)
        max_id = id if id > max_id

      App.Box.ID = max_id

    return @store.find('box')

  init: ->
    ## HACK TODO FIX
    ## IF I REMOVE THIS THEN
    ## ON model ABOVE, IT WILL THINK THAT
    ## THERE ARE NO STORED MODELS
    @store.find('box').get('length')

App.BoxesController = Ember.ArrayController.extend
  actions:
    create: (box)->
      my_index = box.get('index')
      @store.all('box').forEach (item)->
        if item.get('index') > my_index
          item.incrementProperty('index')
          item.save()

      App.Box.ID += 1
      @store.createRecord('box',
        id: App.Box.ID
        index: my_index + 1
      ).save()

    delete: (box)->
      return if @store.all('box').get('length') is 1
      return unless confirm("Delete box with id #{box.get('id')}?")

      @incrementProperty 'boxesDeleted'

      my_index = box.get('index')
      @store.all('box').forEach (item)->
        if item.get('index') > my_index
          item.decrementProperty('index')
          item.save()

      box.deleteRecord()
      box.save()

    clearState: ->
      @store.all('box').forEach (item)->
        item.deleteRecord()
        item.save()
      window.location.reload()

  colorHandler: new ColorHandler()

  sortProperties: ['index']

  sortAscending: true

  sortedBoxes: Ember.computed.sort('model', 'sortProperties')

  boxesDeleted: 0

  boxesTotal: (->@get('model.length')).property('@each')

  updateBoxes: (->
    sorted_boxes = @get('model').sortBy('index')

    # Neighbourhood numbering
    i = 0
    while i < sorted_boxes.get('length')
      this_box = sorted_boxes[i]
      my_size = this_box.get('size')
      prev_box = sorted_boxes[i-1] or null
      next_box = sorted_boxes[i+1] or null

      if prev_box
        if prev_box.get('size') is my_size
          prev_box.set('next', this_box)
        else
          prev_box.set('next', null)

      if next_box
        if next_box.get('size') is my_size
          next_box.set('prev', this_box)
        else
          next_box.set('prev', null)
      i++

    # Highlighting
    @get('model').filterBy('highlight', true).forEach (item)->
      item.set('highlight', false)
    last_object = sorted_boxes.get('lastObject')
    last_object and last_object.set('highlight', true)
  ).observes('content.length')

  backgroundColor: (->
    color = @get('colorHandler').calculateInitialColor(@get('content.length'))
    "background-color:#{color};"
  ).property('content.length')

##Box
App.Box = DS.Model.extend
  index: DS.attr('number')

  next: null

  prev: null

  nextId: ( ->
    if @get('next') then @get('next.id') else ''
  ).property('next')

  prevId: ( ->
    if @get('prev') then @get('prev.id') else ''
  ).property('prev')

  highlight: false

  color: (->
    index = @get('index')
    "mod#{index % 4 or 4}"
  ).property('index')

  size: (->
    index = @get('index')
    switch (index % 6)
      when 1,2,3
        my_row = 'third'
      when 4,5
        my_row = 'half'
      when 0
        my_row = 'full'
    return my_row
  ).property('index')

  classes: (->
    size = @get('size')
    color = @get('color')
    highlight = if @get('highlight') is true then 'highlight' else ''
    "box #{size} #{color} #{highlight}"
  ).property('color', 'size', 'highlight')

App.Box.ID = 0