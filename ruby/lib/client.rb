# This is the base class for the VerticalResponse API.
# It contains common functionality that other classes can use to connect to the
# API and make REST calls to it.

require 'httparty'
require_relative 'response'

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

        def embed_resource(resource, resource_id = nil)
          @embed_resource = resource
          @embed_resource_id = resource_id if resource_id
        end

        def class_for_resource(original_class, id = nil)
          # Create a new anonymous class to prevent conflicts with other classes
          new_class = Class.new(original_class)
          new_class.embed_resource(resource_name, id)
          new_class
        end

        # Exclude methods that are not supported by the current resource API.
        # This applies for common methods that are shared across all classes:
        #   - Class methods: all, find, create
        #   - Instance methods: update, delete, stats
        def exclude_methods(*methods)
          @excluded_methods = methods
        end

        def validate_supported_method!(method)
          if @excluded_methods && @excluded_methods.include?(method.to_sym)
            raise NotImplementedError,
              "This method is not supported for the #{ class_name } class"
          end
        end

        # Returns the base URI of the VerticalResponse API.
        # It builds the URI based on the values from the API configuration file.
        # 'host' must be defined (unless host_uri is specified as an input param)
        # otherwise the method will raise an exception.
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

          paths = ['api', 'v1']
          paths << @embed_resource.to_s if @embed_resource
          paths << @embed_resource_id.to_s if @embed_resource_id
          URI.join(uri, File.join(*paths))
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

        def class_name
          # Use the superclass name if the current class name is not defined
          # (e.g. for annonymous classes)
          name || superclass.name
        end

        def resource_name
          # Manually pluralize just by adding an 's' and underscore manually
          # We want this wrapper to be Rails-independent
          "#{ class_name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase }s"
        end

        def id_regexp
          /\d+/
        end

        def id_attribute_name
          'id'
        end

        # Get the ID of a resource based on a given URL
        def resource_id_from_url(url)
          url.match(/#{ resource_name }\/(#{ id_regexp })/)[1]
        end

        ##################################
        # Common object oriented methods #
        ##################################

        # Resource URI for the current class
        def resource_uri(*additional_paths)
          uri = base_uri
          if additional_paths.any?
            # Convert all additional paths to string
            additional_paths = additional_paths.map do |path|
              # We need to escape each path in case it contains caracters that
              # are not appropriate to use as part of an URL.
              # Unescape and then escape again in case the path is already escaped
              URI::escape(URI::unescape(path.to_s))
            end
            uri = File.join(uri, *additional_paths)
          end
          uri
        end

        # Returns a collection of current class objects.
        # Useful for when we need to have an object oriented way to
        # handle a list of items from an API response
        def object_collection(response)
          response.handle_collection do |response_item|
            self.new(response_item)
          end
        end

        # Returns all the objects of the current class
        def all(options = {})
          validate_supported_method!(:all)

          uri = uri_with_options(resource_uri, options)
          response = Response.new get(uri)

          object_collection(response)
        end

        # Find and return an object of the current class based on its ID
        def find(id, options = {})
          validate_supported_method!(:find)

          uri = uri_with_options(resource_uri(id), options)
          response = Response.new get(uri)

          self.new(response)
        end

        # Creates a new object of the current class with the parameters provided
        def create(params)
          validate_supported_method!(:create)

          response = Response.new post(
            resource_uri,
            build_params(params)
          )
          self.new(response)
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
        if @id.nil? && response
          if response.attributes && response.attributes.has_key?(self.class::id_attribute_name)
            @id = response.attributes[self.class::id_attribute_name]
          elsif url
            # This case is useful if we need the ID right after a call
            # that does not return any atributes, like create
            @id = self.class.resource_id_from_url(url)
          end
        end
        @id
      end

      def url
        response.url
      end

      def update(params)
        self.class.validate_supported_method!(:update)

        response = Response.new self.class.put(
          self.class.resource_uri(id),
          self.class.build_params(params)
        )
        self.class.new(response)
      end

      def delete
        self.class.validate_supported_method!(:delete)

        Response.new self.class.delete(self.class.resource_uri(id))
      end

      # Returns the summary stats for the current object
      def stats(options = {})
        self.class.validate_supported_method!(:stats)

        if response.links && response.links.has_key?('stats')
          uri = response.links['stats']['url']
        else
          uri = self.class.uri_with_options(
            self.class.resource_uri(id, 'stats'),
            options
          )
        end

        Response.new self.class.get(uri)
      end
    end
  end
end
