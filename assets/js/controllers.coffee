angular.module('lifechart.controllers', []).
  controller('EventsController', ['$scope', '$routeParams', '$location', 'Event', ($scope, $routeParams, $location, Event) ->
    if $routeParams.month && $routeParams.year
      $scope.currentDate = moment(new Date($routeParams.year, $routeParams.month, 1))
    else
      $scope.currentDate = moment().startOf('month')

    groupByDate = ->
      $scope.eventsByDate = _($scope.events).groupBy (event) -> moment(event.start).format('MMMM DD, MMM')

    fetchData = ->
      $scope.events = Event.get({month: $scope.currentDate.month(), year: $scope.currentDate.year()})
      $scope.events.$promise.then(groupByDate)

    fetchData()
    $scope.prevMonth = ->
      $scope.currentDate.subtract('month', 1)
      #fetchData()
      $location.path('/events/' + $scope.currentDate.year() + '/' + $scope.currentDate.month())
      

    $scope.nextMonth = ->
      $scope.currentDate.add('month', 1)
      #fetchData()
      $location.path('/events/' + $scope.currentDate.year() + '/' + $scope.currentDate.month())

    $scope.selectCategory = (event, category) ->
      event.category = category
      event.$update()

    $scope.hasCategory = (event) ->
      event.category != null

    $scope.timeOf = (event) ->
      moment(event.start).format('hA')

    $scope.categories = window.categories
  ])

