google_calendar = require('../calendar-api.js.coffee')

exports.index = (req, res) =>
  google_calendar.getCalendarList req.session.auth_token, (result) =>
    calendarList = if result && result.items then result.items else result
    res.render('index', {
      title: 'Express'
      calendars: calendarList
    })

exports.events = (req, res) =>
  google_calendar.getCalendarItems req.session.auth_token, req.query.calendarId, (result) =>
    console.log(result)
    eventList = if result && result.items then result.items else result
    res.render('events', {
      title: 'Express'
      events: eventList
    })