'use strict'

###*
 # @ngdoc function
 # @name hyyVotingFrontendApp.controller:SignUpCtrl
 # @description
 # # SignUpCtrl
 # Controller of the hyyVotingFrontendApp
###
angular.module 'hyyVotingFrontendApp'
  .controller 'SignUpCtrl', (SessionSrv, $scope, $location) ->
    @loading = false
    @submitted = false
    @error = null
    @email = null

    @requestLink = (email) ->
      @loading = true

      SessionSrv.requestLink(email).then(
        (data) =>
          console.log "Success requesting link", data
          @submitted = true

        (failure) =>
          console.error "Failed requesting link", failure
          @error = failure

      ).catch(
        (e) =>
          # TODO report to Rollbar
          console.error "Wat happened", e
          @error = e
      ).finally =>
        @loading = false

    return
