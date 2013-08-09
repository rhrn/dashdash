'use strict';

app = angular.module 'dashdash', ['ngCookies', 'ngResource']

app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider
    .when '/',
      templateUrl: 'default.html'
      controller: 'defaultController'
    .when '/showcase',
      templateUrl: 'showcase.html'
      controller: 'showcaseController'
    .when '/orders',
      templateUrl: 'orders.html'
      controller: 'ordersController'
    .when '/goods',
      templateUrl: 'goods.html'
      controller: 'goodsController'
    .when '/user',
      templateUrl: 'user.html'
      controller: 'userController'
    .otherwise
      redirectTo: '/'

  console.log 'config'
  return
]

app.factory 'Auth', ['$rootScope', '$http', '$cookies', ($rootScope, $http, $cookies) ->

    Auth = $rootScope.$new()

    Auth.$on 'join', (event, data) ->
      $cookies.user = JSON.stringify data
      return

    Auth.$on 'logout', (event, data) ->
      $cookies.user = JSON.stringify data
      return

    Auth.user = ->
      JSON.parse $cookies.user || "{}"

    Auth.join = ->
    Auth.logout = ->
    Auth.isAuthed = ->
    Auth.token = ->
      JSON.parse($cookies.user).token

    Auth
]

app.factory 'Api', ['$resource', 'Auth', ($resource, Auth) ->

  console.log 'Api'

  Api = $resource '//localhost\\:8005/api/v1/:method/:id', {},
    get:
      method: 'GET'
      isArray: false
      headers:
        Auth: Auth.token()
    put:
      method: 'PUT'
      headers:
        Auth: Auth.token()
    post:
      method: 'POST'
      headers:
        Auth: Auth.token()
  Api
]

app.directive 'uploadControls', ->
  console.log 'directive upload controls'
  templateUrl: 't-upload-controls'
  link: (scope, el, attrs) ->
    console.log scope, el, attrs
    return

app.directive 'file', ->
  console.log 'directive file'
  link: (scope, el, attrs) ->
    el.bind 'change', (event) ->
      files = @files || event.target.files
      scope.uploadFiles attrs.file, files
      console.log attrs, el
      return
    return

app.controller 'goodsController', ['$scope', 'Api', ($scope, Api) ->

  Goods = Api.bind method: 'goods'

  goods = Goods.get -> 
    console.log 'get all goods', goods
    $scope.goods = goods
    return

  $scope.new = ->
    $scope.item = {}
    return

  $scope.add = ->
    Goods.post $scope.item, (data) ->
      $scope.goods[data["_id"]] = data
      $scope.item = null
      return
    return

  $scope.save = ->
    id = $scope.item["_id"]
    Goods.put id:id, $scope.item, (data) ->
      $scope.goods[id] = data
      $scope.item = null
      return
    return

  $scope.edit = (id) ->
    console.log 'click edit', id
    Goods.get id:id, (data) ->
      console.log 'edit data', data
      $scope.item = data
      return
    return

  $scope.delete = (id) ->
    delete $scope.goods[id]
    Goods.delete id:id
    return

  $scope.uploadFiles = (id, files) ->
    console.log 'scope', id, files
    return

  $scope.uploadUrlFiles = (id, urls) ->
    Upload = Api.bind method: 'goodsUploadUrls', id: id
    Upload.post urls:urls, (data) ->
      $scope.goods[id].images[id] = data
      return
    return

  console.log 'goodsController'
  return
]

app.controller 'ordersController', ['$scope', 'Api', ($scope, Api) ->

  Orders = Api.bind method: 'orders'

  orders = Orders.get -> 
    $scope.orders = orders

  console.log 'ordersController'
  return
]

app.controller 'authController', ['$scope', 'Auth', '$http', ($scope, Auth, $http) ->

  $scope.user = Auth.user()

  Auth.$on 'join', (event, data) ->
    console.log 'on join', event, data
    $scope.user = data
    return

  $scope.logout = ->
    console.log 'emit logout'
    Auth.$emit('logout', {});
    $scope.user = {}
    return

  return
]

app.controller 'joinController', ['$scope', 'Auth', '$http', ($scope, Auth, $http) ->

  $scope.user = Auth.user()

  Auth.$on 'logout', (event, data) ->
    console.log 'on logout', event, data
    $scope.user = data
    $scope.error = data
    return

  $scope.join = ->
    $http.post('//localhost:3000/api/v1/join', $scope.user)
      .success (data) ->
        console.log 'success', data 
        $scope.user = data
        Auth.$emit('join', data);
        return
      .error (data) ->
        console.log 'error', data 
        $scope.error = data
        return
    return

  return
]

app.controller 'defaultController', ['$scope', 'Auth', '$http', ($scope, Auth, $http) ->
  console.log 'defaultController'
  return
]

app.controller 'userController', ['$scope', 'Auth', '$http', ($scope, Auth, $http) ->
  console.log 'userController'
  return
]

app.controller 'showcaseController', ['$scope', 'Auth', '$http', ($scope, Auth, $http) ->
  console.log 'showcaseController'
  return
]
