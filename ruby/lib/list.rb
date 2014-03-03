# Class that represents a list resource from the VerticalResponse API.
# It has the ability to make REST calls to the API, as well as to wrap
# the list objects we get as response.
#
# NOTE: This class does not necessarily include all the available methods
# the API has for the list resource. You can consider this an initial approach
# for an object oriented solution that you can expand according to your needs.

require File.expand_path(File.join(File.dirname(__FILE__), 'contact'))

module VerticalResponse
  module API
    class List < Client
      class << self
        # Base URI for the List resource
        def resource_uri(id = nil)
          uri = File.join(base_uri.to_s, 'lists')
          uri = File.join(uri, id.to_s) if id
          uri
        end

        # Base URI for the Contact resource, but nested inside the List resource
        def contacts_uri(list_id)
           File.join(resource_uri(list_id), 'contacts')
        end

        # Returns all of the user's lists
        def all(options = {})
          uri = uri_with_options(resource_uri, options)
          response = Response.new get(uri)

          response.handle_collection do |response_item|
            List.new(response_item)
          end
        end

        # Returns a user's list based on its ID
        def find(id, options = {})
          uri = uri_with_options(resource_uri(id), options)
          response = Response.new get(uri)

          List.new(response)
        end

        # Creates a list with the parameters provided
        def create(params)
          Response.new post(
            resource_uri,
            build_params(params)
          )
        end
      end

      # Returns the details for a list as a new instance of the List class
      def details(options = {})
        uri = self.class.uri_with_options(response.url, options)
        response = Response.new self.class.get(uri)

        List.new(response)
      end

      # Returns all the contacts that belong to the list
      def contacts(options = {})
        uri = self.class.uri_with_options(self.class.contacts_uri(id), options)
        response = Response.new self.class.get(uri)

        response.handle_collection do |response_item|
          Contact.new(response_item)
        end
      end

      # Creates a contact for the list with the parameters provided
      def create_contact(params)
        uri = self.class.contacts_uri(id)
        Response.new self.class.post(
          uri,
          self.class.build_params(params)
        )
      end
    end
  end
end
