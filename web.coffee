fs = require 'fs'
http = require 'http'
express = require 'express' 
mongodb = require 'mongodb'
mongo = require './configure/mongodb.js'
ObjectID = mongodb.ObjectID
assert = require 'assert'
app = express()

app.use express.static __dirname
app.use express.bodyParser()

# upload by url
app.post '/api/v1/goodsUploadUrls/:id', (req, res) ->

  staticPath = 'static/media/goods/'
  id = req.params.id
  urls = req.body.urls
  filename = urls.substr urls.lastIndexOf('/') + 1
  fullPath = staticPath + id + '/' + filename

  savefile = ->
    console.log fullPath
    file = fs.createWriteStream fullPath
    request = http.get urls, (response) ->
      response.pipe file
      mongo.db.collection 'goods', (err, collection) ->
        assert.equal null, err

        img = {}
        img["images." + filename.replace('.', '-')] = 
          src: '/' + fullPath
          
        collection.findAndModify _id: new ObjectID(id), [], 
            $set: img
            {},
            (err, doc) ->
              assert.equal null, err
              console.log doc 
              return
        return
      res.json id:id, src: '/' + fullPath
      return
    return

  fs.exists staticPath + id, (exists) ->
    if not exists
      fs.mkdir staticPath + id, ->
        savefile()
      return
    else
      savefile()
      return
  return
  
# upload by files
app.post '/api/v1/upload', (req, res) ->

# find all orders
app.get '/api/v1/orders', (req, res) ->
  mongo.db.collection 'orders', (err, collection) ->
    assert.equal null, err
    collection.find().sort({}).toArray (err, data) ->
      assert.equal null, err
      res.send data

# find all goods
app.get '/api/v1/goods', (req, res) ->
  mongo.db.collection 'goods', (err, collection) ->
    assert.equal null, err
    collection.find().sort({}).toArray (err, data) ->
      assert.equal null, err
      send = {}
      for i of data
        send[data[i]["_id"]] = data[i]
      res.send send

# get one goods
app.get '/api/v1/goods/:id', (req, res) ->
  id = req.params.id
  mongo.db.collection 'goods', (err, collection) ->
    assert.equal null, err 
    collection.findOne _id: new ObjectID(id), (err, data) ->
      res.json (data) 

# create one goods item
app.post '/api/v1/goods', (req, res) ->
  mongo.db.collection 'goods', (err, collection) ->
    assert.equal null, err
    collection.insert req.body, (err, data) ->
      res.json data[0]

# update one goods item
app.put '/api/v1/goods/:id', (req, res) ->
  id = req.params.id
  doc = req.body
  delete doc['_id']

  mongo.db.collection 'goods', (err, collection) ->
    assert.equal null, err
    collection.findAndModify _id: new ObjectID(id), [], doc, (err, data) ->
      res.send doc

# remove one
app.delete '/api/v1/goods/:id', (req, res) ->
  id = req.params.id
  mongo.db.collection 'goods', (err, collection) ->
    assert.equal null, err
    collection.remove
      _id: new ObjectID(id)
    , (err, data) ->
      res.send data

module.exports.app = app
