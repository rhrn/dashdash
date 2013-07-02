'use strict';
app = angular.module 'app', []

app.controller 'authController', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http) ->

  $rootScope.$on 'join', (event, data) ->
    #console.log 'on join', event, data
    $scope.user = data
    return

  $scope.logout = ->
    #console.log 'emit logout'
    $rootScope.$emit('logout', {});
    $scope.user = {}
    return

  return
]

app.controller 'joinController', ['$rootScope', '$scope', '$http', ($rootScope, $scope, $http) ->

  $rootScope.$on 'logout', (event, data) ->
    #console.log 'on logout', event, data
    $scope.user = data
    return

  $scope.join = ->
    $http.post('//localhost:3000/api/v1/join', $scope.user)
      .success (data) ->
        #console.log 'success', data 
        $scope.user = data
        $rootScope.$emit('join', data);
        return
      .error (data) ->
        #console.log 'error', data 
        $scope.error = data
        return
    return

  return
]
