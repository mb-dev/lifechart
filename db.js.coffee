config = require('./settings')
mongoose = require( 'mongoose' )

Schema   = mongoose.Schema
ObjectId = mongoose.Schema.Types.ObjectId

User = new Schema
  user_id: String
  name: String

CalendarEntry = new Schema
  user_id: ObjectId
  title: String
  start: Date
  end: Date
  category: String

exports.models =
  User: mongoose.model( 'User', User )
  CalendarEntry: mongoose.model( 'CalendarEntry', CalendarEntry )

mongoose.connect("mongodb://localhost:27017/" + config.database.name)

exports.mongoose = mongoose

# redis
redis = require("redis")
exports.redisClient = redis.createClient(null, null, {detect_buffers: true});
exports.calendarEntryToJson = (item) ->
  {
    id: item.id.toString()
    title: item.title
    date: item.date
    category: item.category
  }
  
