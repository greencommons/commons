module Api
  class Authenticator
    include ActiveSupport::SecurityUtils

    def initialize(authorization)
      @authorization = authorization
    end

    def api_key
      return nil unless access_key && secret_key
      api_key = ApiKey.enabled.find_by(access_key: access_key)

      return api_key if api_key && secure_compare_with_hashing(api_key.secret_key, secret_key)
    end

    def access_key
      @access_key ||= credentials[0]
    end

    def secret_key
      @secret_key ||= credentials[1]
    end

    def credentials
      @credentials ||= @authorization.present? ? @authorization.split(' ')[1].split(':') : []
    end

    private

    def secure_compare_with_hashing(a, b)
      secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
    end
  end
end
