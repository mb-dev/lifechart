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
  time: Date
  category: String

mongoose.model( 'User', User )
mongoose.model( 'CalendarEntry', CalendarEntry )

mongoose.connect("mongodb://localhost:27017/" + config.database.name)