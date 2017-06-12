mime = Mime::Type.lookup('application/vnd.api+json').symbol
ActionDispatch::Request.parameter_parsers[mime] = lambda do |body|
  JSON.parse(body)
end
