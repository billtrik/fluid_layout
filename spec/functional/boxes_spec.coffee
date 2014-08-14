describe 'Boxes', ->
  @timeout(5000)

  before ->
    @server = app.listen(3001)
    @url = 'http://localhost:3001'
    @browser = new Browser()

    @create_box = (box_element = null)->
      box_element ?= @browser.queryAll('.box')[0]
      @browser.fire(box_element, 'click')

    @get_data = -> JSON.parse(@browser.window.localStorage.getItem('boxes_data'))
    return

  after ->
    @browser.close()
    @server.close()

  describe 'Layout', ->
    before (done)->
      @browser.visit @url, =>
        @box = @browser.queryAll('.box')[0]
        @header = @box.querySelector('header')
        done()
      return

    after ->
      @browser.window.localStorage.clear()

    it 'should have a header', ->
      expect(@box.querySelectorAll('header')).to.have.length(1)

    it 'should have its ID inside the header', ->
      expect(@header.querySelector('h1').textContent).to.equal '1'

    it 'should have a delete element inside the header', ->
      expect(@header.querySelectorAll('.delete')).to.have.length(1)

    it 'should have a "prev" element', ->
      expect(@box.querySelectorAll('.prev')).to.have.length(1)

    it 'should have a "next" element', ->
      expect(@box.querySelectorAll('.next')).to.have.length(1)

  describe 'Coloring', ->
    before (done)->
      @browser.visit @url, =>
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @browser.wait()

        @boxes = @browser.queryAll('.box')
        done()
      return

    after ->
      @browser.window.localStorage.clear()

    it 'should add a "mod1" class to every 1mod4 box', ->
      expect(@boxes[0].className).to.include 'mod1'
      expect(@boxes[4].className).to.include 'mod1'

    it 'should add a "mod2" class to every 2mod4 box', ->
      expect(@boxes[1].className).to.include 'mod2'

    it 'should add a "mod3" class to every 3mod4 box', ->
      expect(@boxes[2].className).to.include 'mod3'

    it 'should add a "mod4" class to every 4mod4 box', ->
      expect(@boxes[3].className).to.include 'mod4'

    it 'should add a "highlight" class to the last box', ->
      expect(@boxes[4].className).to.include 'highlight'

  describe 'Sizes', ->
    before (done)->
      @browser.visit @url, =>
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @browser.wait()

        @boxes = @browser.queryAll('.box')
        done()
      return

    after ->
      @browser.window.localStorage.clear()

    it 'should add a "third" class to every 1mod6 box', ->
      expect(@boxes[0].className).to.include 'third'
      expect(@boxes[6].className).to.include 'third'

    it 'should add a "third" class to every 2mod6 box', ->
      expect(@boxes[1].className).to.include 'third'
      expect(@boxes[7].className).to.include 'third'

    it 'should add a "third" class to every 3mod6 box', ->
      expect(@boxes[2].className).to.include 'third'
      expect(@boxes[8].className).to.include 'third'

    it 'should add a "half" class to every 4mod6 box', ->
      expect(@boxes[3].className).to.include 'half'
      expect(@boxes[9].className).to.include 'half'

    it 'should add a "half" class to every 5mod6 box', ->
      expect(@boxes[4].className).to.include 'half'

    it 'should add a "full" class to every 6mod6 box', ->
      expect(@boxes[5].className).to.include 'full'

  describe 'Behaviour', ->
    beforeEach (done)->
      @browser.visit @url, =>
        @box = @browser.queryAll('.box')[0]
        done()
      return

    afterEach ->
      @browser.window.localStorage.clear()

    context 'When the mouse hovers into a box', ->
      beforeEach (done)->
        @browser.fire @box, 'mouseover', done

      it 'should add a hover class to the box element', ->
        expect(@box.className).to.include 'hover'

      it 'should add a box_hover class to the body element', ->
        expect(@browser.body.className).to.include 'box_hover'

    context 'When the mouse hovers out of a box', ->
      beforeEach (done)->
        @browser.fire @box, 'mouseover', =>
          @browser.fire @box, 'mouseout', done

      it 'should add a hover class to the box element', ->
        expect(@box.className).to.not.include 'hover'

      it 'should add a box_hover class to the body element', ->
        expect(@browser.body.className).to.not.include 'box_hover'

    context 'When a click is made on a box', ->
      before ->
        @click = (callback)=> @browser.fire @box, 'click', callback

      it 'creates a new box', (done)->
        prev_length = @browser.queryAll('.box').length
        @click =>
          expect(@browser.queryAll('.box').length).to.equal(prev_length + 1)
          done()
        return

      it 'places new box after the one been clicked', (done)->
        boxes = @browser.queryAll('.box')
        last_box = boxes[boxes.length - 1]

        @click =>
          new_boxes = @browser.queryAll('.box')
          expect(new_boxes[new_boxes.length - 2]).to.equal(last_box)
          done()
        return

      it 'makes container2\'s background darker', (done)->
        container2 = @browser.query('#container2')
        prev_background = container2.getAttribute('style')
        @click ->
          new_background = container2.getAttribute('style')
          expect(new_background).to.not.equal(prev_background)
          expect(new_background).to.equal('background-color: rgb(242, 242, 242);')
          done()
        return

    context 'When a click is made on a boxes\' delete button', ->
      before ->
        @click = (box, callback)=> @browser.fire box.querySelector('.delete'), 'click', callback

      context 'When there are more than one boxes', ->
        beforeEach (done)->
          @create_box()
          @create_box()
          @create_box()
          @browser.wait()
          @browser.onconfirm 'Delete box with id 4?', true

          @boxes = @browser.queryAll('.box')
          @box = @boxes[1]
          done()

        afterEach ->
          @browser.onconfirm 'Delete box with id 4?'

        it 'deletes the box', (done)->
          prev_length = @browser.queryAll('.box').length

          @click @box, =>
            new_length = @browser.queryAll('.box').length
            expect(new_length).to.equal(prev_length - 1)
            done()
          return

        it 'confirms with the user the the box is about to be deleted', (done)->
          @click @box,  =>
            expect(@browser.prompted('Delete box with id 4?')).to.be.true
            done()
          return

        it 'makes container2\'s background lighter', (done)->
          container2 = @browser.query('#container2')
          prev_background = container2.getAttribute('style')
          @click @box, ->
            new_background = container2.getAttribute('style')
            expect(new_background).to.not.equal(prev_background)
            expect(new_background).to.equal('background-color: rgb(233, 233, 233);')
            done()
          return

      context 'When there is only one box', ->
        it 'does not delete last box', (done)->
          prev_length = @browser.queryAll('.box').length

          @click @box, =>
            new_length = @browser.queryAll('.box').length
            expect(new_length).to.equal(prev_length)
            done()
          return

        it 'does not ask for confirmation from the user', ->
          expect(@browser.prompted('Delete box with id 1?')).to.be.false

