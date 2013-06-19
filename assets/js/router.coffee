App.Router.map ->

App.IndexRoute = Ember.Route.extend
  model: ->
    return App.Event.find()
