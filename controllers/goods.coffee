goods = require '../models/goods.js'

module.exports =

  uploadUrls: (req, res) ->
    goods.uploadUrls req, res
    return

  upload: (req, res) ->
    goods.upload req, res
    return

  find: (req, res) ->
    goods.find (data) ->
      res.send data
      return
    return

  findOne: (req, res) ->
    id = req.params.id
    goods.findOne id, (data) ->
      res.send data
      return
    return

  create: (req, res) ->
    goods.create req.body, (data) ->
      res.send data
      return
    return

  update: (req, res) ->
    id = req.params.id
    doc = req.body
    goods.update id, doc, (data) ->
      res.send data
      return
    return

  delete: (req, res) ->
    id = req.params.id
    goods.delete id, (data) ->
      res.send data
      return
    return
