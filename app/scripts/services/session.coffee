'use strict'

angular.module 'hyyVotingFrontendApp'
  .service 'SessionSrv', ($window, Restangular, elections) ->

    @requestLink = (email) ->
      Restangular
        .all('sessions')
        .all('link')
        .post(email: email)

    @signIn = (token) ->
      Restangular.all('sessions').post(token: token).then(
        (data) => @save data
      )

    @getJwt = ->
      $window.sessionStorage.getItem 'jwt'

    @getUser = ->
      try
        JSON.parse $window.sessionStorage.getItem 'user'
      catch e
        console.log "Could not get current user", e
        {}

    @save = (data) ->
      new Promise (resolve, reject) ->
        elections.save data.elections
        $window.sessionStorage.setItem 'jwt', data.jwt
        $window.sessionStorage.setItem 'user', JSON.stringify data.user

        resolve()

    return
