App.Event = DS.Model.extend
  title: DS.attr('string')
  start: DS.attr('date')
  end: DS.attr('date')
  category: DS.attr('string')

  itemDate: (->
    moment(@get('start')).format('dddd, DD MMM') 
  ).property('start')

  hours: (->
    startMoment = moment(@get('start')) 
    endMoment = moment(@get('end'))

    endMoment.diff(startMoment, 'hours')
  ).property('start', 'end')