module Api
  class Authenticator
    include ActiveSupport::SecurityUtils

    def initialize(authorization)
      @authorization = authorization
    end

    def credentials
      @credentials ||= Hash[@authorization.scan(/(\w+)[:=] ?"?([\w|:]+)"?/)]
    end

    def api_key
      return nil if credentials['api_key'].blank?

      access_key, key = credentials['api_key'].split(':')
      api_key = access_key && key && ApiKey.enabled.find_by(access_key: access_key)

      return api_key if api_key && secure_compare_with_hashing(api_key.key, key)
    end

    private

    def secure_compare_with_hashing(a, b)
      secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
    end
  end
end
