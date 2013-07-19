window.App = Ember.Application.create()

Ember.Handlebars.helper 'debug2', (options) ->
  console.log("Current Context")
  console.log("====================")
  console.log(this)
  console.log(options)