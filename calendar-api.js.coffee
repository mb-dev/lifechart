googleapis = require('googleapis');
OAuth2Client = googleapis.OAuth2Client
moment = require('moment')
config = require('./settings')

exports.getOAuthToken = (code, callback) =>
  googleapis.discover('calendar', 'v3').execute (err, client) =>
    oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
    oauth2Client.getToken code, (err, tokens) =>
      callback(tokens)

exports.getAuthUrl = (callback) =>
  oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
  url = oauth2Client.generateAuthUrl({
    access_type: 'online',
    scope: 'https://www.googleapis.com/auth/calendar'
  })
  callback(url)

exports.getCalendarList = (auth_token, callback) =>
  if !auth_token || auth_token.length == 0
    callback(null, [])
    return

  googleapis.discover('calendar', 'v3').execute (err, client) =>
    oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
    oauth2Client.credentials = auth_token

    client.calendar.calendarList.list().withAuthClient(oauth2Client).execute (err, result) =>
      callback(null, result)

exports.getCalendarItems = (auth_token, calendarId, callback) =>
  if !auth_token
    callback(null, [])
    return

  googleapis.discover('calendar', 'v3').execute (err, client) =>
    oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
    oauth2Client.credentials = auth_token

    timeMin = moment().startOf('month').toDate().toISOString()

    console.log(timeMin)

    client.calendar.events.list({calendarId: calendarId, timeMin: timeMin}).withAuthClient(oauth2Client).execute (err, result) =>
      console.log(err) if err
      callback(err, result)
