require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Repp < OmniAuth::Strategies::OAuth
      option :name, 'repp'

      option :client_options, {:authorize_path => '/oauth/authorize',
                               :site => 'https://api.myrepp.com',
                               :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil}

      uid { access_token.params[:user_id] }

      info do
        {
          :nickname => raw_info['username'],
          :preferredName => raw_info['preferredName']['full'],
          :badgeUrls => {
            :reppIdentityCard => raw_info['reppIdentityCard'],
            :reppIdentityLarge => raw_info['reppIdentityLarge'],
            :reppIdentityMedium => raw_info['reppIdentityMedium'],
            :reppIdentitySmall => raw_info['reppIdentitySmall'],
            :reppLogo => raw_info['reppLogo']
          },
          :profileUrl => raw_info['profileUrl']
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('/people/me').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

    end
  end
end