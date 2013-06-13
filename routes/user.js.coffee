googleapis = require('googleapis');
OAuth2Client = googleapis.OAuth2Client

config = require('../settings')

getOAuthToken = (code, callback) =>
  googleapis.discover('calendar', 'v3').execute (err, client) =>
    oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
    oauth2Client.getToken code, (err, tokens) =>
      callback(tokens)


exports.list = (req, res) =>
  res.send("respond with a resource")

exports.auth = (req, res) =>
  oauth2Client = new OAuth2Client(config.google.CLIENT_ID, config.google.CLIENT_SECRET, config.global.redirect_url)
  url = oauth2Client.generateAuthUrl({
    access_type: 'online',
    scope: 'https://www.googleapis.com/auth/calendar'
  })

  res.redirect(url)


exports.authcallback = (req, res) =>
  getOAuthToken req.query.code, (auth_token) =>
    req.session.auth_token = auth_token
    res.redirect('/')
    #getCalendarList(client, oauth2Client)