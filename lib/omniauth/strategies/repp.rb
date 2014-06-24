require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Repp < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end
      class UnknownSignatureAlgorithmError < NotImplementedError; end

      option :name, 'repp'

      option :client_options, {
        :site => 'https://api.myrepp.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token'
      }

      uid { access_token.params[:user_id] }

      info do
        {
          :name => raw_info['displayName'],
          :email => raw_info['email'],
          :nickname => raw_info['username'],
          :first_name => raw_info['preferredName']['first'],
          :last_name => raw_info['preferredName']['last'],
          :image => raw_info['photoUrl'],
          :urls => {
            'Profile' => raw_info['profileUrl']
          },
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/people/me').parsed || {}
      end

      def callback_phase
        if request.params.key?('code')
          super
        end
      rescue NoAuthorizationCodeError => e
        fail!(:no_authorization_code, e)
      rescue UnknownSignatureAlgorithmError => e
        fail!(:unknown_signature_algorithm, e)
      end

      def build_access_token
        headers = { 'Authorization' => authorization_header }
        verifier = request.params['code']
        client.auth_code.get_token(
          verifier,
          { :redirect_uri => callback_url, :headers => headers }.merge(token_params.to_hash(:symbolize_keys => true)),
          deep_symbolize(options.auth_token_params)
        )
      end

    private

      def authorization_header
        header = Base64.encode64("#{options.client_id}:#{options.client_secret}")
        "Basic #{header}"
      end

    end
  end
end