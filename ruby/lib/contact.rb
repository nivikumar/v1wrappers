# Class that represents a contact resource from the VerticalResponse API.
# It has the ability to make REST calls to the API, as well as to wrap
# the contact objects we get as response.
#
# NOTE: This class does not necessarily include all the available methods
# the API has for the contact resource. You can consider this an initial
# approach for an object oriented solution that you can expand according to
# your needs.

require_relative 'message'

module VerticalResponse
  module API
    class Contact < Client
      class << self
        # Base URI for the Contact resource
        def base_uri(*args)
          @base_uri ||= File.join(super.to_s, 'contacts')
        end

        def fields(options = {})
          uri = uri_with_options(File.join(resource_uri, 'fields'), options)
          Response.new get(uri)
        end
      end

      # Remove methods that are not supported by the Contact API.
      # Contact does not support the 'stats' method for now
      exclude_methods :stats

      def initialize(*args)
        super
        @list_class = self.class.class_for_resource(List, id)
        @message_class = self.class.class_for_resource(Message, id)
      end

      # Returns all the lists this contact belongs to
      def lists(options = {})
        @list_class.all(options)
      end

      # Returns all the messages targetted to the current contact
      def messages(options = {})
        @message_class.all(options)
      end
    end
  end
end
