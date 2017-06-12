module Authentication
  extend ActiveSupport::Concern

  AUTH_SCHEME = 'GC'.freeze

  included do
    before_action :validate_auth_scheme
    before_action :authenticate_client
  end

  private

  def validate_auth_scheme
    unless authorization_request =~ /^#{AUTH_SCHEME} */
      unauthorized!('Default Realm')
    end
  end

  def authenticate_client
    unauthorized!('Default Realm') unless api_key
  end

  def unauthorized!(realm)
    headers['WWW-Authenticate'] = %(#{AUTH_SCHEME} realm="#{realm}")
    render(status: 401)
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end

  def authenticator
    @authenticator ||= Api::Authenticator.new(authorization_request)
  end

  def api_key
    @api_key ||= lambda do
      key = "api_keys/#{authenticator.secret_key}"

      Rails.cache.fetch(key, expires_in: 24.hours) do
        authenticator.api_key
      end
    end.call
  end

  def current_user
    @current_user ||= api_key.try(:user)
  end
end
