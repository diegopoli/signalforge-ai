module Ai
  class ClientFactory
    def self.build
      options = {
        access_token: ProviderConfig.api_key,
        request_timeout: 30
      }
      options[:uri_base] = ProviderConfig.base_uri if ProviderConfig.base_uri.present?

      OpenAI::Client.new(**options)
    end
  end
end
