class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::ParamsParser::ParseError => error
    if env['CONTENT_TYPE'] =~ %r(application\/vnd\.api\+json)
      error_output = "There was a problem in the JSON you submitted: #{error.class}"
      return [
        400, { 'Content-Type' => 'application/vnd.api+json' },
        [{ status: 400, errors: [
          {
            status: 400,
            title: error.class,
            details: error_output
          }
        ] }.to_json]
      ]
    else
      raise error
    end
  end
end
