config = require('../settings')
google_calendar = require('../calendar-api.js.coffee')

exports.list = (req, res) =>
  res.send("respond with a resource")

exports.auth = (req, res) =>
  google_calendar.getAuthUrl (url) =>
    res.redirect(url)


exports.authcallback = (req, res) =>
  google_calendar.getOAuthToken req.query.code, (auth_token) =>
    req.session.auth_token = auth_token
    res.redirect('/')