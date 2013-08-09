mongodb = require 'mongodb'
ObjectID = mongodb.ObjectID
mongo = require '../configure/mongodb.js'
assert = require 'assert'

module.exports =

  # find all orders
  find: (callback) ->
    mongo.db.collection 'orders', (err, collection) ->
      assert.equal null, err
      collection.find().sort({}).toArray (err, data) ->
        assert.equal null, err
        callback data
        return
      return
    return
