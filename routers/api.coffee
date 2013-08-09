goods = require '../controllers/goods.js'
orders = require '../controllers/orders.js'

module.exports = (app) ->

  app.get '/api/v1/orders', orders.find

  app.get '/api/v1/goods', goods.find
  app.get '/api/v1/goods/:id', goods.findOne
  app.post '/api/v1/goods', goods.create
  app.put '/api/v1/goods/:id', goods.update
  app.delete '/api/v1/goods/:id', goods.delete

  app.post '/api/v1/goodsUploadUrls/:id', goods.uploadUrls
  app.post '/api/v1/upload', goods.upload
