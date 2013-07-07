config = require('../settings')
google_calendar = require('../calendar-api.js.coffee')
db = require('../db.js.coffee')
async = require('async')
moment = require('moment')

exports.index = (req, res) =>
#  ul
#      each calendar in calendars
#        li
#          b= calendar.summary
#          p= calendar.description
#          a(href='/events?calendarId=' + calendar.id) View
#  db.redisClient.get 'auth_token', (err, auth_token) =>
#    google_calendar.getCalendarList JSON.parse(auth_token), (result) =>
#      calendarList = if result && result.items then result.items else result

  res.render('index', {
    title: 'Express'
  })

exports.sync = (req, res) =>
  insertIntoDatabase = (item, callback) ->
    if item.status != "confirmed"
      callback(null)
      return

    console.log(item.start)
    console.log(item.end)

    item = new db.models.CalendarEntry
      user_id: null,
      title: item.summary
      start: (item.start.dateTime || item.start.date)
      end: (item.end.dateTime || item.end.date)
      category: null

    item.save (err) =>
      callback(err)

  getAllEvents = (auth_token, callback) ->
    eventsResult = []
    nextPageToken = null

    async.doWhilst(
      (callback) =>
        google_calendar.getCalendarItems auth_token, nextPageToken, config.global.main_calendar, (err, result) =>
          eventsResult = eventsResult.concat(result.items)
          nextPageToken = result.nextPageToken
          callback(err)
      , () =>
        nextPageToken?
      , (err) =>
        callback(err, eventsResult)
    )
  async.waterfall [
    (callback) =>
      db.models.CalendarEntry.remove (err) ->
        callback(err)
    (callback) =>
      db.redisClient.get 'auth_token', (err, auth_token) ->
        callback(err, JSON.parse(auth_token))
    (auth_token, callback) ->
      getAllEvents(auth_token, callback)
    ], (err, result) =>
      eventList = result

      async.each eventList, insertIntoDatabase, (err) =>
        res.redirect('/')

exports.putEvent = (req, res) =>
  db.models.CalendarEntry.findById req.params.id, (err, calendarEntry) =>
    calendarEntry.category = req.body.event.category
    calendarEntry.save (err) =>
      res.json
        event: db.calendarEntryToJson(calendarEntry)
  

exports.getAll = (req, res) =>
  toJsonObject = (item, callback) ->
    callback(null, db.calendarEntryToJson(item))

  params = {}
  if req.query.month && req.query.year
    beginningTime = moment([req.query.year, req.query.month]).startOf('month')
    endTime = moment([req.query.year, req.query.month]).endOf('month')
    
    params['start'] = { $lt: endTime, $gt: beginningTime }

  db.models.CalendarEntry.find(params).exec (err, calendarEntries) =>
    async.map calendarEntries, toJsonObject, (err, results) ->
      res.json
        events: results