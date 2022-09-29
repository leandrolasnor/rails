# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Meilisearch::Index, type: :context do
  let(:search_result) { { hits: [], query: '{:query=>""}' } }

  context 'on #search' do
    it do
      described_class.address do |index|
        expect(index.search(query: '').slice('query', 'hits').to_json).to eq(search_result.slice(:query, :hits).to_json)
      end
    end
  end
end
