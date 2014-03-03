# Class that represents a list resource from the VerticalResponse API.
# It has the ability to make REST calls to the API, as well as to wrap
# the list objects we get as response.
#
# NOTE: This class does not necessarily include all the available methods
# the API has for the list resource. You can consider this an initial approach
# for an object oriented solution that you can expand according to your needs.

require File.expand_path(File.join(File.dirname(__FILE__), 'list'))

module VerticalResponse
  module API
    class Email < Client
      class << self
        # Base URI for the Email resource
        def resource_uri(*additional_paths)
          uri = File.join(base_uri.to_s, 'messages', 'emails')
          if additional_paths.any?
            # Convert all additional paths to string
            additional_paths = additional_paths.map(&:to_s)
            uri = File.join(uri, *additional_paths)
          end
          uri
        end

        # Returns a user's email based on its ID
        def find(id, options = {})
          uri = uri_with_options(resource_uri(id), options)
          response = Response.new get(uri)

          Email.new(response)
        end

        # Creates an email with the parameters provided
        def create(params)
          Response.new post(
            resource_uri,
            build_params(params)
          )
        end
      end

      # Returns the details for an email as a new instance of the Email class
      def details(options = {})
        uri = self.class.uri_with_options(response.url, options)
        response = Response.new self.class.get(uri)

        Email.new(response)
      end

      # Launches an email and return the response object
      def launch(params = {})
        # Supports receiving an array of List objects (Object Oriented)
        lists = params.delete(:lists)
        if lists
          params[:list_ids] ||= []
          params[:list_ids] += lists.map do |list|
            list.respond_to?(:id) ? list.id : list.to_i
          end
          # Remove duplicate IDs, if any
          params[:list_ids].uniq!
        end

        Response.new self.class.post(
          self.class.resource_uri(id),
          self.class.build_params(params)
        )
      end

      # Returns the summary stats for an email
      def summary_stats(options = {})
        uri = self.class.uri_with_options(
          self.class.resource_uri(id, 'stats'),
          options
        )

        Response.new self.class.get(uri)
      end
    end
  end
end
