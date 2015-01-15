require "uri"

require "omise/util"

module Omise
  module Testing
    class Resource
      def initialize(url, path, key)
        @uri = URI.parse(url)
        @uri.path = [@uri.path, path].join
        @key = key
      end

      def get(attributes = {})
        Omise::Util.load_response(read_file("get"))
      end

      def patch(attributes = {})
        Omise::Util.load_response(read_file("patch"))
      end

      def delete(attributes = {})
        Omise::Util.load_response(read_file("delete"))
      end

      def post(attributes = {})
        Omise::Util.load_response(read_file("post"))
      end

      def read_file(verb)
        File.read(File.expand_path(File.join(
          Omise::LIB_PATH, "..", "test", "fixtures",
          [@uri.host, @uri.path, "-#{verb}.json"].join
        )))
      end
    end
  end
end
