# frozen_string_literal: true

module ::Meilisearch
  module Index
    URL = ENV.fetch('MEILISEARCH_URL', 'http://localhost:7700')
    ACCESS_KEY = Rails.application.credentials.dig(:meilisearch, :access_key)

    class << self
      def latech_search_address
        yield(MeiliSearch::Client.new(URL, ACCESS_KEY).index(__method__))
      end
    end
  end
end
