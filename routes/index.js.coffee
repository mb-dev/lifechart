config = require('../settings')
google_calendar = require('../calendar-api.js.coffee')
db = require('../db.js.coffee')
async = require('async')
moment = require('moment')

exports.index = (req, res) =>
  res.render('index', {
    title: 'Lifechart',
    categories: config.categories
  })

exports.sync = (req, res) =>
  insertIntoDatabase = (item, callback) ->
    if item.status != "confirmed"
      callback(null)
      return

    db.models.CalendarEntry.findOne {googleId: item.id}, (err, calendarEntry) ->
      if calendarEntry
        calendarEntry.title = item.summary
        calendarEntry.start = item.start
        calendarEntry.end = item.end
        calendarEntry.updated = item.updated
        calendarEntry.save (err) ->
          callback(err)
      else
        item = new db.models.CalendarEntry
          googleId: item.id
          user_id: null
          title: item.summary
          start: (item.start.dateTime || item.start.date)
          end: (item.end.dateTime || item.end.date)
          category: null
          updated: item.updated

        item.save (err) =>
          callback(err)

  getAllEvents = (auth_token, user, callback) ->
    eventsResult = []
    nextPageToken = null

    async.doWhilst(
      (callback) =>
        google_calendar.getCalendarItems auth_token, nextPageToken, user.last_sync, config.global.main_calendar, (err, result) =>
          eventsResult = eventsResult.concat(result.items)
          nextPageToken = result.nextPageToken
          callback(err)
      , () =>
        nextPageToken?
      , (err) =>
        callback(err, user, eventsResult)
    )
  async.waterfall [
    (callback) =>
      db.redisClient.get 'auth_token', (err, auth_token) ->
        callback(err, JSON.parse(auth_token))
    (auth_token, callback) =>
      db.getCurrentUser (err, user) ->
        callback(err, auth_token, user)
    (auth_token, user, callback) =>
      if !user.last_sync
        db.models.CalendarEntry.remove (err) ->
          callback(err, auth_token, user)
      else
        callback(null, auth_token, user)
    (auth_token, user, callback) ->
      getAllEvents(auth_token, user, callback)
    (user, result, callback) ->
      eventList = result
      async.each eventList, insertIntoDatabase, (err) =>
        callback(err, user)
    (user, callback) ->
      user.last_sync = Date.now()
      user.save (err) ->
        callback(err)
    ], (err, result) =>
      if err
        console.log('error')
        console.log(err)
      
      res.redirect('/')

exports.putEvent = (req, res) =>
  db.models.CalendarEntry.findById req.params.id, (err, calendarEntry) =>
    console.log("Updating " + req.params.id.toString() + " to category: " + req.body.event.category)
    console.log(calendarEntry)
    calendarEntry.category = req.body.event.category
    calendarEntry.save (err) =>
      console.log('success')
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