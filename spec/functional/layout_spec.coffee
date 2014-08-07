describe 'Layout', ->
  @timeout(5000)

  before (done)->
    @server = app.listen(3001)
    @url = 'http://localhost:3001'
    @browser = new Browser()
    @browser.visit(@url).finally(done)

  after ->
    @browser.close()
    @server.close()
