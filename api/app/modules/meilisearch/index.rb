# frozen_string_literal: true

module ::Meilisearch
  module Index
    URL = ENV.fetch('MEILISEARCH_URL', 'http://localhost:7700')
    ACCESS_KEY = Rails.application.credentials.dig(:meilisearch, :access_key)

    class << self
      def address
        yield(get(__method__))
      end

      def album
        yield(get(__method__))
      end

      def get(entity)
        MeiliSearch::Client.new(
          URL,
          ACCESS_KEY
        ).index(
          Rails.env.test? ? entity.to_s.insert(0, '_') : entity
        )
      end
    end
  end
end
