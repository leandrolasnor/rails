# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nuuvem::SalesController, type: :routing do
  describe 'routing' do
    it 'route to #upload' do
      expect(post: '/nuuvem/sales/upload').to route_to('nuuvem/sales#upload')
    end

    it 'route to #search' do
      expect(get: '/nuuvem/sales/search').to route_to('nuuvem/sales#search')
      expect(get: '/nuuvem/sales/search/query').to route_to('nuuvem/sales#search', query: 'query')
    end
  end
end
