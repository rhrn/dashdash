orders = require '../models/orders.js'

module.exports =

  find: (res, req) ->

    orders.find (data) ->
      req.send data

    return
