# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::AlbumsController, type: :routing do
  describe 'routing' do
    it 'route to #search' do
      expect(get: '/moat/albums/search').to route_to('moat/albums#search')
    end

    it 'route to #show' do
      expect(get: '/moat/albums/1').to route_to('moat/albums#show', id: '1')
    end

    it 'route to #create' do
      expect(post: '/moat/albums').to route_to('moat/albums#create')
    end

    it 'route to #update via PUT' do
      expect(put: '/moat/albums/1').to route_to('moat/albums#update', id: '1')
    end

    it 'route to #update via PATCH' do
      expect(patch: '/moat/albums/1').to route_to('moat/albums#update', id: '1')
    end

    it 'route to #destroy' do
      expect(delete: '/moat/albums/1').to route_to('moat/albums#destroy', id: '1')
    end

    describe 'route to #show' do
      context 'without id param' do
        it 'end-point not found' do
          expect(get: '/albums').to route_to(controller: 'api', action: 'not_found', path: 'albums')
        end
      end
    end
  end
end
