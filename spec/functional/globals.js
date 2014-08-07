// IS THIS NOT NEEDED SINCE THIS IS A COFFE FILE??
// require 'coffee-script/register'

// process.env.NODE_ENV = 'test'

chai = require('chai')
should = chai.should()
expect = chai.expect
assert = chai.assert

app = require('../../server')
// use zombie.js as headless browser
Browser = require('zombie');