# Client errors that can be raised from VerticalResponse API response errors.

require File.expand_path(File.join(File.dirname(__FILE__), 'error'))

module VerticalResponse
  module API
    class Error < StandardError
      attr_accessor :code, :api_response
    end

    class ConfigurationError < Error; end
  end
end
