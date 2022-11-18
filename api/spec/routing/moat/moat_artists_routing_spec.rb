# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::ArtistsController do
  describe 'routing' do
    it 'route to #artists' do
      expect(get: 'moat/artists').to route_to('moat/artists#index')
    end
  end
end
