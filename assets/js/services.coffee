# Demonstrate how to register services
# In this case it is a simple value service.
angular.module('lifechart.services', ['ngResource'])
  .factory('Event', ($resource) -> 
    return $resource('/events/:id', {id: '@id'}, {
      get: {method: 'GET', params: {month: 'month', year: 'year'}, isArray:true, transformResponse: (data, headers) ->
        addHours = (event)->
          event.hours = moment(event.end).diff(moment(event.start), 'hours')
        data = JSON.parse(data)
        addHours(event) for event in data
        data
      },
      update: {method: 'PUT'}
    })
  )