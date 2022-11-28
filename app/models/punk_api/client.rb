# frozen_string_literal: true

require "httpx/adapters/faraday"

module PunkApi
  class Client
    class Error < StandardError
      attr_reader :response

      def initialize(response)
        @response = response

        super <<~MSG
          Server responded with status #{response.status}
          Request: #{response.env.method.upcase} #{response.env.url}
          message: #{build_message}
        MSG
      end

      def build_message
        body = response.body
        msg = body["message"] if body.is_a? Hash
        msg || body.to_s
      end
    end

    class NotFoundError < Error; end

    PER_PAGE = 10

    attr_reader :base_url, :adapter

    def initialize(base_url: nil, adapter: nil)
      @base_url = base_url.presence || Rails.configuration.x.punk_api.base_url
      @adapter = adapter || :httpx
    end

    def beers(name: nil, page: 1, per_page: PER_PAGE)
      query = {page:, per_page:}
      query[:beer_name] = name if name.present?

      get("beers", query).body
    end

    def beer(id:)
      id = id.to_i
      response = get("beers/#{id}")
      return response.body.first if response.body&.first&.fetch("id", nil) == id

      raise Error, response
    end

    private

    def get(url, query = nil)
      response = connection.get(url, query)
      raise NotFoundError, response if response.status == 404
      raise Error, response unless response.success?

      response
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |f|
        f.adapter(*adapter)
        f.headers = {"Accept" => "application/json"}
        f.response :json # Decode json response body
        f.use :http_cache, store: http_cache_store, logger: Rails.logger
      end
    end

    def http_cache_store
      ActiveSupport::Cache::FileStore.new(Rails.root.join("tmp/http_cache"))
    end
  end
end
