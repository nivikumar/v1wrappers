# Class that represents a contact resource from the VerticalResponse API.
# It has the ability to make REST calls to the API, as well as to wrap
# the contact objects we get as response.
#
# NOTE: This class does not necessarily include all the available methods
# the API has for the contact resource. You can consider this an initial
# approach for an object oriented solution that you can expand according to
# your needs.

require File.expand_path(File.join(File.dirname(__FILE__), 'client'))

module VerticalResponse
  module API
    class Contact < Client
      class << self
        # Base URI for the Contact resource
        def resource_uri(id = nil)
          uri = File.join(base_uri.to_s, 'contacts')
          uri = File.join(uri, id.to_s) if id
          uri
        end

        # Returns all of the user's contacts
        def all(options = {})
          uri = uri_with_options(resource_uri, options)
          response = Response.new get(uri)

          response.handle_collection do |response_item|
            Contact.new(response_item)
          end
        end

        # Returns a user's contact based on its ID
        def find(id, options = {})
          uri = uri_with_options(resource_uri(id), options)
          response = Response.new get(uri)

          Contact.new(response)
        end

        # Creates a contact with the parameters provided
        def create(params)
          response = Response.new post(
            resource_uri,
            build_params(params)
          )
        end
      end

      # Returns the details for a contact as a new instance of the Contact class
      def details(options = {})
        uri = self.class.uri_with_options(response.url, options)
        response = Response.new self.class.get(uri)

        Contact.new(response)
      end
    end
  end
end
