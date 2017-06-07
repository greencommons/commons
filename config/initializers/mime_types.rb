ActionDispatch::Request.parameter_parsers[Mime::Type.lookup('application/vnd.api+json').symbol] = lambda do |body|
  JSON.parse(body)
end
