# frozen_string_literal: true

MeiliSearch::Rails.configuration = {
  meilisearch_host: ENV.fetch('MEILISEARCH_URL', 'http://localhost:7700'),
  meilisearch_api_key: Rails.application.credentials.dig(:meilisearch, :access_key),
  pagination_backend: :kaminari,
  timeout: 2,
  max_retries: 1
}
