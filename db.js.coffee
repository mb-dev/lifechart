config = require('./settings')
mongoose = require( 'mongoose' )

Schema   = mongoose.Schema
ObjectId = mongoose.Schema.Types.ObjectId

User = new Schema
  name: String
  last_sync: Date

CalendarEntry = new Schema
  googleId: String
  user_id: ObjectId
  title: String
  start: Date
  end: Date
  category: String
  updated: Date

CalendarEntry.index({'googleId', 1})

exports.models =
  User: mongoose.model( 'User', User )
  CalendarEntry: mongoose.model( 'CalendarEntry', CalendarEntry )

mongoose.connect("mongodb://localhost:27017/" + config.database.name)

exports.mongoose = mongoose

exports.getCurrentUser = (callback) ->
  exports.models.User.findOne {name: config.database.userName}, (err, user) ->
    if user
      callback(err, user)
      return

    user = new exports.models.User({name: config.database.userName, last_sync: null})
    user.save (err) ->
      callback(err, user)

# redis
redis = require("redis")
exports.redisClient = redis.createClient(null, null, {detect_buffers: true});
exports.calendarEntryToJson = (item) ->
  {
    id: item.id.toString()
    title: item.title
    start: item.start
    end: item.end
    category: item.category
  }
  