# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::AddresesController do
  describe 'routing' do
    it 'route to #search' do
      expect(get: '/latech/addreses/search').
        to route_to('latech/addreses#search')
      expect(get: '/latech/addreses/search/rua%20das%20flores').
        to route_to('latech/addreses#search', query: 'rua das flores')
    end

    it 'route to #capture' do
      expect(get: '/latech/addreses/capture/23058500').
        to route_to('latech/addreses#capture', zip: '23058500')
    end
  end
end
