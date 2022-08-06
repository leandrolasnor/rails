# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::AlbumsController, type: :request do
  let(:album) { create(:album) }
  let(:album_attributes) do
    {
      name: Faker::Games::Pokemon.name,
      year: rand(1948..Time.zone.now.year).to_i,
      artist_id: [1, 2, 3, 4, 5].sample
    }
  end
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end
  let(:admin_headers_credentials) do
    admin_sign_in_response = sign_in(user: { email: 'otherteste@teste.com', password: '123456' })
    {
      uid: admin_sign_in_response.dig(:headers, 'uid'),
      client: admin_sign_in_response.dig(:headers, 'client'),
      'access-token': admin_sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe 'GET /show' do
    before do
      allow(ShowAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      get(album_path(album.id), headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(ShowAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'GET /search' do
    before do
      allow(SearchAlbumsService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      get(albums_search_path, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(SearchAlbumsService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'PUT /update' do
    before do
      allow(UpdateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      put(album_path(album.id), params: { album: { name: Faker::Games::Pokemon.name } }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(UpdateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    before do
      allow(UpdateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      patch(album_path(album.id), params: { album: { name: Faker::Games::Pokemon.name } }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(UpdateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    before do
      allow(CreateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      post(albums_path, params: { album: album_attributes }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(CreateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    before do
      allow(RemoveAlbumService).to receive(:call).and_return(successful_response)
    end

    context 'when its rendered a unauthorized response' do
      it 'the user is not admin' do
        delete(album_path(album.id), headers: headers_credentials, as: :json)
        expect(response.body.blank?).to eq true
        expect(RemoveAlbumService).not_to have_received(:call)
        expect(response).to be_unauthorized
      end
    end

    context 'when its rendered a successful response' do
      before do
        allow(RemoveAlbumService).to receive(:call).and_return(successful_response)
      end

      it 'the user is admin' do
        delete(album_path(album.id), headers: admin_headers_credentials, as: :json)
        expect(response.body).to eq successful_body_content
        expect(RemoveAlbumService).to have_received(:call).once
        expect(response).to be_successful
      end
    end
  end
end
