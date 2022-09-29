# frozen_string_literal: true

module ::Meilisearch
  module Index
    URL = ENV.fetch('MEILISEARCH_URL', 'http://localhost:7700')
    ACCESS_KEY = Rails.application.credentials.dig(:meilisearch, :access_key)

    class << self
      def address
        yield(MeiliSearch::Client.new(URL, ACCESS_KEY).index(Rails.env.test? ? __method__.to_s.insert(0, '_') : __method__))
      end
    end
  end
end
