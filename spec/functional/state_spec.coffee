describe 'State', ->
  @timeout(5000)

  before ->
    @server = app.listen(3001)
    @url = 'http://localhost:3001'
    @browser = new Browser()

    @create_box = (box_element = null)->
      box_element ?= @browser.queryAll('.box')[0]
      @browser.fire(box_element, 'click')
    return

  after ->
    @browser.close()
    @server.close()

  context 'When there is no prior state', ->
    afterEach ->
      @browser.window.localStorage.clear()

    it 'initiates with one box', (done)->
      @browser.visit @url, =>
        expect(@browser.queryAll('.box')).to.have.length(1)
        done()

  context 'when there was a prior state', ->
    beforeEach (done)->
      @browser.visit @url, =>
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @create_box()
        @browser.wait()

        @browser.reload(done)

    afterEach ->
      @browser.window.localStorage.clear()

    it 'resumes last state', (done)->
      @browser.visit @url, =>
        expect(@browser.queryAll('.box')).to.have.length(8)
        done()

  context 'when the clear state button is pressed', ->
    before (done)->
      @browser.visit @url, =>
        @create_box()
        @create_box()
        @browser.wait()

        @last_length = @browser.history.length
        @last_href = @browser.location.href

        @browser.pressButton '.clear_state', done

    afterEach ->
      @browser.window.localStorage.clear()

    it 'resets localstorage', ->
      expected_data = "{\"box\":{\"records\":{\"1\":{\"id\":\"1\",\"index\":1}}}}"
      data = @browser.window.localStorage.getItem('fluid_layout')
      expect(expected_data).to.equal(data)

    it 'resets the boxes', ->
      expect(@browser.queryAll('.box')).to.have.length(1)
