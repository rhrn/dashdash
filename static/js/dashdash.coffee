'use strict';
app = angular.module 'app', ['ngCookies']

app.factory 'User', ['$rootScope', '$cookies', ($rootScope, $cookies) ->

    User = $rootScope.$new()

    User.$on 'join', (event, data) ->
      $cookies.user = JSON.stringify data
      return

    User.$on 'logout', (event, data) ->
      $cookies.user = JSON.stringify data
      return

    User.init = JSON.parse $cookies.user || "{}"

    User
]

app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $routeProvider
    .when '/orders',
      templateUrl: 'orders.html'
      controller: 'ordersController'
    .when '/showcase',
      templateUrl: 'showcase.html'
      controller: 'showcaseController'
    .when '/goods',
      templateUrl: 'goods.html'
      controller: 'goodsController'
    .otherwise
      templateUrl: 'default.html'
      controller: 'defaultController'

  return
]

app.controller 'defaultController', ['$scope', 'User', '$http', ($scope, User, $http) ->
  console.log 'defaultController'
]

app.controller 'goodsController', ['$scope', 'User', '$http', ($scope, User, $http) ->
  console.log 'goodsController'
]

app.controller 'showcaseController', ['$scope', 'User', '$http', ($scope, User, $http) ->
  console.log 'showcaseController'
]

app.controller 'ordersController', ['$scope', 'User', '$http', ($scope, User, $http) ->
  console.log 'ordersController'
]

app.controller 'authController', ['$scope', 'User', '$http', ($scope, User, $http) ->

  $scope.user = User.init

  User.$on 'join', (event, data) ->
    #console.log 'on join', event, data
    $scope.user = data
    return

  $scope.logout = ->
    #console.log 'emit logout'
    User.$emit('logout', {});
    $scope.user = {}
    return

  return
]

app.controller 'joinController', ['$scope', 'User', '$http', ($scope, User, $http) ->

  $scope.user = User.init

  User.$on 'logout', (event, data) ->
    #console.log 'on logout', event, data
    $scope.user = data
    $scope.error = data
    return

  $scope.join = ->
    $http.post('//localhost:3000/api/v1/join', $scope.user)
      .success (data) ->
        #console.log 'success', data 
        $scope.user = data
        User.$emit('join', data);
        return
      .error (data) ->
        #console.log 'error', data 
        $scope.error = data
        return
    return

  return
]
