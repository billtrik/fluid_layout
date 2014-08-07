http = require('http')
express = require('express')
app = express()
module.exports = app

app.use(express.static(__dirname + '/public', { 'keepAlive': false }))
app.get '/', (req, res)->
  res.set 'Connection', 'close'
  res.sendFile __dirname + '/index.html'

if !module.parent
  http.createServer(app).listen 8080, ->
    console.log 'Server listening on port 8080'