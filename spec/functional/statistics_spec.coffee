describe 'Statistics', ->
  @timeout(5000)

  before ->
    @server = app.listen(3001)
    @url = 'http://localhost:3001'
    @browser = new Browser()

    @create_box = (box = null)->
      box ?= @browser.queryAll('.box')[0]
      @browser.fire(box, 'click')

    @delete_box = (box = null, callback)->
      box ?= @browser.queryAll('.box')[0]
      @browser.fire box.querySelector('.delete'), 'click', callback

  after ->
    @browser.close()
    @server.close()

  describe 'Layout', ->
    before (done)->
      @browser.visit @url, =>
        @stats = @browser.query('#stats')
        done()

    it 'creates statitics container element', ->
      expect(@stats).to.not.equal(null)

    it 'creates boxes count element', ->
      expect(@stats.querySelectorAll('.sum')).to.have.length(1)

    it 'creates deleted boxes element', ->
      expect(@stats.querySelectorAll('.deleted')).to.have.length(1)

  context 'On page load', ->
    before (done)->
      @browser.visit @url, =>
        @sum = @browser.query('#stats .sum span')
        @deleted = @browser.query('#stats .deleted span')

        done()

    it 'updates total boxes count', ->
      expect(@sum.textContent).to.equal '1'

    it 'updates deleted boxes count', ->
      expect(@deleted.textContent).to.equal '0'

  context 'When a box is deleted', ->
    before (done)->
      @browser.onconfirm 'Delete box with id 3?', true

      @browser.visit @url, =>
        @create_box()
        @create_box()
        @browser.wait()

        @box = @browser.queryAll('.box')[1]
        @sum = @browser.query('#stats .sum span')
        @deleted = @browser.query('#stats .deleted span')

        @delete_box @box, done

    after ->
      @browser.onconfirm 'Delete box with id 3?'
      @browser.window.localStorage.clear()

    it 'updates total boxes count', ->
      expect(@sum.textContent).to.equal '2'

    it 'updates deleted boxes count', ->
      expect(@deleted.textContent).to.equal '1'

  context 'When a box is created', ->
    before (done)->
      @browser.visit @url, =>
        @sum = @browser.query('#stats .sum span')
        @deleted = @browser.query('#stats .deleted span')

        @create_box()
        @browser.wait()
        done()

    after ->
      @browser.window.localStorage.clear()

    it 'updates total boxes count', ->
      expect(@sum.textContent).to.equal '2'

    it 'does not change deleted boxes count', ->
      expect(@deleted.textContent).to.equal '0'

  context 'When the page is refreshed', ->
    before (done)->
      @browser.visit @url, =>
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @browser.wait()

        @browser.reload =>
          @sum = @browser.query('#stats .sum span')
          @deleted = @browser.query('#stats .deleted span')

          done()

    after ->
      @browser.window.localStorage.clear()

    it 'shows previous total boxes count', ->
      expect(@sum.textContent).to.equal '8'

    it 'resets the deleted boxes count', ->
      expect(@deleted.textContent).to.equal '0'
