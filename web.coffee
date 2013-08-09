express = require 'express'
app = express()
api = require './routers/api.js'

api(app)

app.use express.static __dirname
app.use express.bodyParser()

module.exports.app = app
