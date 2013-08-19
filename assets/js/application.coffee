# Declare app level module which depends on filters, and services
angular
  .module('lifechart', ['ngRoute', 'lifechart.filters', 'lifechart.services', 'lifechart.directives', 'lifechart.controllers'])
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.when('/events', {templateUrl: 'partials/events', controller: 'EventsController'})
    $routeProvider.when('/events/:year/:month', {templateUrl: 'partials/events', controller: 'EventsController'})
    $routeProvider.otherwise({redirectTo: '/events'})
  ])