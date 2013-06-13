googleapis = require('googleapis');
OAuth2Client = googleapis.OAuth2Client

config = require('../settings')

getCalendarList = (auth_token, callback) =>
  if !auth_token
    callback([])
    return

  googleapis.discover('calendar', 'v3').execute (err, client) =>
    oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
    oauth2Client.credentials = auth_token

    client.calendar.calendarList.list().withAuthClient(oauth2Client).execute (err, result) =>
      callback(result)


exports.index = (req, res) =>
  getCalendarList req.session.auth_token, (result) =>
    console.log(result)
    calendarList = if result && result.items then result.items else result
    res.render('index', {
      title: 'Express'
      calendars: calendarList
    })
