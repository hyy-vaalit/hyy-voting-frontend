'use strict'

angular.module 'hyyVotingFrontendApp'
  .factory 'errorMonitor', (SessionSrv) ->

    error: (error, msg = "") ->
      Rollbar.error(error, {msg: msg, user: SessionSrv.getUser()})
      console.error "Reported unexpected error to Rollbar:", error, msg, SessionSrv.getUser()
