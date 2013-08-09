fs = require 'fs'
http = require 'http'
mongodb = require 'mongodb'
ObjectID = mongodb.ObjectID
mongo = require '../configure/mongodb.js'
assert = require 'assert'

module.exports =

  # upload by url
  uploadUrls: (req, res) ->

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
  upload: (req, res) ->
    return

  # find all goods
  find: (callback) ->
    mongo.db.collection 'goods', (err, collection) ->
      assert.equal null, err
      collection.find().sort({}).toArray (err, data) ->
        assert.equal null, err
        send = {}
        for i of data
          send[data[i]["_id"]] = data[i]
        callback send
        return
      return
    return

  # get one goods
  findOne: (id, callback) ->
    mongo.db.collection 'goods', (err, collection) ->
      assert.equal null, err 
      collection.findOne _id: new ObjectID(id), (err, data) ->
        callback data
        return
      return
    return

  # create one goods item
  create: (doc, callback) ->
    mongo.db.collection 'goods', (err, collection) ->
      assert.equal null, err
      collection.insert doc, (err, data) ->
        callback data[0]
        return
      return
    return

  # update one goods item
  update: (id, doc, callback) ->
    delete doc['_id']
    mongo.db.collection 'goods', (err, collection) ->
      assert.equal null, err
      collection.findAndModify _id: new ObjectID(id), [], doc, (err, data) ->
        callback data
        return
      return
    return

  # remove one
  delete: (id, callback) ->
    mongo.db.collection 'goods', (err, collection) ->
      assert.equal null, err
      collection.remove _id: new ObjectID(id) , (err, data) ->
        callback data
        return
      return
    return
