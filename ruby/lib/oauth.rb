# This class provides users the ability to generate oAuth tokens for the
# VerticalResponse API.
#
# Check the examples/sample code to know how to use this class.

require_relative 'client'

module VerticalResponse
  module API
    class OAuth < Client
      # We expect HTML format as the API might redirect to a signin page or
      # return errors in HTML format
      format :html

      class << self
        # Overwrite this method as we don't need to setup headers for
        # OAuth calls
        def assign_headers(*args)
        end

        # Base URI for the OAuth calls
        def base_uri(*args)
          @base_uri ||= File.join(super.to_s, 'oauth')
        end

        def authorize(redirect_uri = config['oauth_redirect_uri'],
                      client_id = config['client_id'])
          uri = uri_with_options(
            resource_uri('authorize'),
            { :client_id => client_id, :redirect_uri => redirect_uri }
          )
          get(uri)
        end

        def access_token(client_secret,
                         auth_code,
                         redirect_uri = config['oauth_redirect_uri'],
                         client_id = config['client_id'])
          uri = uri_with_options(
            resource_uri('access_token'),
            {
              :client_id => client_id,
              :client_secret => client_secret,
              :code => auth_code,
              :redirect_uri => redirect_uri
            }
          )
          get(uri)
        end
      end
    end
  end
end
