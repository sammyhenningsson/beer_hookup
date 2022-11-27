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
          message: #{response.body}
        MSG
      end
    end

    PER_PAGE = 10

    attr_reader :base_url, :adapter

    def initialize(base_url: nil, adapter: nil)
      @base_url = base_url.presence || Rails.configuration.x.punk_api.base_url
      @adapter = adapter || :httpx
    end

    def beers(name: nil, page: 1, per_page: PER_PAGE)
      query = {page:, per_page:}
      query[:beer_name] = name if name.present?

      get("beers", query)
    end

    private

    def get(url, query)
      response = connection.get("beers", query)
      raise Error, response unless response.success?

      response.body
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |f|
        f.adapter(*adapter)
        f.headers = {"Accept" => "application/json"}
        f.response :json # Decode json response body
      end
    end
  end
end
