describe 'Layout', ->
  @timeout(5000)

  before (done)->
    @server = app.listen(3001)
    @url = 'http://localhost:3001'
    @browser = new Browser()
    @browser.visit(@url, done)

  after ->
    @browser.close()
    @server.close()


  it 'should have a loader div', ->
    expect(@browser.queryAll('#loader')).to.have.length(1)
    expect(@browser.query('#loader').nodeName).to.equal('DIV')

  it 'should have a container1 div', ->
    expect(@browser.queryAll('#container1')).to.have.length(1)
    expect(@browser.query('#loader').nodeName).to.equal('DIV')

  it 'should have a container2 div', ->
    expect(@browser.queryAll('#container2')).to.have.length(1)
    expect(@browser.query('#loader').nodeName).to.equal('DIV')

  it 'should have container2 as a child to container1', ->
    parent = @browser.query('#container2').parentNode
    container1 = @browser.query('#container1')

    expect(container1).to.equal(parent)

