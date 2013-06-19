config = require('../settings')
google_calendar = require('../calendar-api.js.coffee')
db = require('../db.js.coffee')
async = require('async')

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

    item = new db.models.CalendarEntry
      user_id: null,
      title: item.summary
      date: (item.start.datetime || item.start.date)
      category: null

    item.save (err) =>
      callback(err)

  async.waterfall [
    (callback) =>
      db.models.CalendarEntry.remove (err) ->
        callback(err)
    (callback) =>
      db.redisClient.get 'auth_token', (err, auth_token) ->
        callback(err, JSON.parse(auth_token))
    (auth_token, callback) ->
      google_calendar.getCalendarItems auth_token, config.global.main_calendar, (err, result) ->
        callback(err, result)
    ], (err, result) =>
      eventList = if result && result.items then result.items else []

      async.each eventList, insertIntoDatabase, (err) =>
        res.redirect('/')

exports.getAll = (req, res) =>
  toJsonObject = (item, callback) ->
    callback(null, {
      title: item.title,
      date: item.date
    })

  db.models.CalendarEntry.find({}).exec (err, calendarEntries) =>
    async.map calendarEntries, toJsonObject, (err, results) ->
      res.json
        events: results