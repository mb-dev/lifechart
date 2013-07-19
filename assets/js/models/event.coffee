App.Event = DS.Model.extend
  title: DS.attr('string')
  start: DS.attr('date')
  end: DS.attr('date')
  category: DS.attr('string')