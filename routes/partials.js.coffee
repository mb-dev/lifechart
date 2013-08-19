exports.partials = (req, res)->
  filename = req.params.filename
  return unless filename # might want to change this
  res.render "partials/#{filename}"