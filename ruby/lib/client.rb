# This is the base class for the VerticalResponse API.
# It contains common functionality that other classes can use to connect to the
# API and make REST calls to it.

require 'httparty'
require File.expand_path(File.join(File.dirname(__FILE__), 'response'))

module VerticalResponse
  module API
    class Client
      include HTTParty

      CONFIG_FILE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'api.yml'))
      CONFIG = YAML.load(File.read(CONFIG_FILE_PATH))

      format :json

      class << self
        def assign_headers(access_token = CONFIG['access_token'],
                           client_id = CONFIG['client_id'])
          headers 'X-Mashery-Oauth-Access-Token' => access_token,
            'X-Mashery-Oauth-Client-Id' => client_id
        end

        # Returns the base URI of the VerticalResponse API.
        # It builds the URI based on the values from the API configuration file.
        # 'host' must be defined, otherwise the method will raise an exception.
        def base_uri(host_uri = nil)
          uri = host_uri
          unless uri
            unless CONFIG['host']
              raise ConfigurationError, 'Configuration option "host" must be defined.'
            end

            uri = URI::Generic.new(
              CONFIG['protocol'] || 'http', # protocol scheme
              nil,                          # user info
              CONFIG['host'],               # host
              CONFIG['port'],               # port
              nil,                          # registry of naming authorities
              nil,                          # path on server
              nil,                          # opaque part
              nil,                          # query data
              nil                           # fragment (part of URI after '#' sign)
            )
          end

          URI.join(uri, 'api/v1')
        end

        def build_params(params)
          params ? { :body => params } : {}
        end

        def uri_with_options(uri, options)
          uri = URI.parse(uri)
          # Overwrite any existing query params
          uri.query = URI.encode_www_form(options) if options.is_a?(Hash) && options.any?

          uri.to_s
        end
      end

      # Set default headers for OAuth authentication
      assign_headers

      attr_accessor :response

      def initialize(response)
        self.response = response
      end

      # Returns the ID of the current object based on the response
      def id
        response.attributes['id']
      end
    end
  end
end
