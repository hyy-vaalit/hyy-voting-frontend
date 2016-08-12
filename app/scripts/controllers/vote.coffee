'use strict'

angular.module 'hyyVotingFrontendApp'
  .controller 'VoteCtrl', ($scope, $location, candidates, coalitions, VoteSrv, errorMonitor) ->

    @debug = false

    @electionId = $location.search().election
    @loadError = false
    @loading = true
    @selected = null
    @submitting = @submitted = false
    @coalitions = []
    @candidates = []
    @savedVote = null

    Promise.all [
      coalitions.get(@electionId),
      candidates.get(@electionId),
      VoteSrv.get(@electionId)
    ]
      .then(
        (results) =>
          @coalitions = results[0]
          @candidates = results[1]

          if !_.isEmpty results[2]
            @savedVote = results[2]
            @selected = @savedVote.candidate_id

        (failure) =>
          @loadError = true
          errorMonitor.error failure, "Fetching coalitions/candidates failed"
      )
      .finally =>
        @loading = false
        $scope.$apply()

    @isProspectSelected = ->
      @selected != null

    @select = (candidate) ->
      return if @submitting || @submitted

      @selected = candidate.id

    @isUnsaved = ->
      return false if !@selected or !@savedVote or _.isEmpty(@savedVote)

      @selected != @savedVote.candidate_id

    @submit = (candidateId) ->
      @submitting = true

      VoteSrv.submit(@electionId, candidateId).then(
        (success) ->
          console.log "Vote submitted for id", candidateId, success

        (failure) =>
          console.error "Vote failed for id", candidateId, failure
          @submitError = true
          errorMonitor.error failure, "Vote failed"

      ).catch(
        (e) =>
          @submitError = true
          errorMonitor.error e, "Vote failed for unknown error."

      ).finally( =>
        @submitted = true
        @submitting = false
      )

    return

  .filter 'candidate', ->
    (candidate, filter) ->
      if candidate?.name == filter?.name && candidate?.number == filter?.number
        return candidate

  .directive 'voteProspect', ->
    restrict: 'E'
    template: '''
      <span translate>.vote-ballot.header-number</span>: <strong>{{ prospect.number }}</strong>
      <br>
      <span translate>.vote-ballot.header-name</span>: <strong>{{ prospect.name }}</strong>
    '''
    scope:
      selected: '=vtSelected'
      all: '=vtAll'

    link: (scope, element, attrs) ->
      scope.$watch 'selected', (newValue, oldValue) ->
        scope.prospect = _.find scope.all, 'id', newValue
