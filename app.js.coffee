config = require('./settings')

# express
express = require('express')
indexRoute = require('./routes/index.js.coffee')
userRoute = require('./routes/user.js.coffee')
http = require('http')
path = require('path')

# database
require( './db.js.coffee' )

app = express()
app.set('port', process.env.PORT || 4000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.cookieParser());
app.use(express.session({secret: '1234567890QWERTY'}));
app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))

if ('development' == app.get('env'))
  app.use(express.errorHandler())

app.get('/', indexRoute.index)
app.get('/events', indexRoute.events)
app.get('/users', userRoute.list)
app.get('/auth', userRoute.auth)
app.get('/oauth2callback', userRoute.authcallback)

http.createServer(app).listen(app.get('port'), =>
  console.log('Express server listening on port ' + app.get('port'))
)