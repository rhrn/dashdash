express = require("express")
mongodb = require("mongodb")
mongo = require("./configure/mongodb.js")
ObjectID = mongodb.ObjectID
assert = require("assert")
app = express()

app.use express.static(__dirname)
app.use express.bodyParser()

# find all orders
app.get "/api/v1/orders", (req, res) ->
  mongo.db.collection "orders", (err, collection) ->
    assert.equal null, err
    collection.find().sort({}).toArray (err, data) ->
      assert.equal null, err
      res.send data

# find all goods
app.get "/api/v1/goods", (req, res) ->
  mongo.db.collection "goods", (err, collection) ->
    assert.equal null, err
    collection.find().sort({}).toArray (err, data) ->
      assert.equal null, err
      res.send data


# create one goods item
app.post "/api/v1/goods", (req, res) ->
  mongo.db.collection "goods", (err, collection) ->
    assert.equal null, err
    collection.insert req.body, (err, data) ->
      res.json data[0]

# update one goods item
app.put "/api/v1/goods/:id", (req, res) ->
  id = req.params.id
  doc = req.body
  delete doc["_id"]

  mongo.db.collection "goods", (err, collection) ->
    assert.equal null, err
    collection.findAndModify
      _id: new ObjectID(id)
    , [], doc, (err, data) ->
      res.send doc

# remove one
app.remove "/api/v1/goods/:id", (req, res) ->
  id = req.params.id
  mongo.db.collection "goods", (err, collection) ->
    assert.equal null, err
    collection.remove
      _id: new ObjectID(id)
    , (err, data) ->
      res.send data

module.exports.app = app
