App.Router.map ->

App.IndexRoute = Ember.Route.extend
  events: 
    changeCategory: (item) ->
      item.set('category', undefined)
      item.get('transaction').commit()

    nextMonth: ->
      date = moment([@controller.get('year'), @controller.get('month')]).add('month', 1)
      @controller.set('month', date.month())
      @controller.set('year', date.year())
      @controller.set("content", App.Event.find({month: @controller.get('month'), year: @controller.get('year')}));

    prevMonth: ->
      date = moment([@controller.get('year'), @controller.get('month')]).subtract('month', 1)
      @controller.set('month', date.month())
      @controller.set('year', date.year())
      @controller.set("content", App.Event.find({month: @controller.get('month'), year: @controller.get('year')}));

    select: (category, item) ->
      item.set('category', category.toString())
      item.get('transaction').commit()

  setupController: (controller) =>
    timeNow = moment()
    controller.set('month', timeNow.month())
    controller.set('year', timeNow.year())
    controller.set("content", App.Event.find({month: controller.get('month'), year: controller.get('year')}));
    controller.set("categories", window.categories)