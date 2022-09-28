# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::AlbumsController, type: :request do
  let(:album) { create(:album) }
  let(:album_attributes) { build(:album).attributes }
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
      allow(Moat::ShowAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      get(moat_album_path(album.id), headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(Moat::ShowAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'GET /search' do
    before do
      allow(Moat::SearchAlbumsService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      get(moat_albums_search_path, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(Moat::SearchAlbumsService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'PUT /update' do
    before do
      allow(Moat::UpdateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      put(moat_album_path(album.id), params: { album: { name: Faker::Games::Pokemon.name } }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(Moat::UpdateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    before do
      allow(Moat::UpdateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      patch(moat_album_path(album.id), params: { album: { name: Faker::Games::Pokemon.name } }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(Moat::UpdateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    before do
      allow(Moat::CreateAlbumService).to receive(:call).and_return(successful_response)
    end

    it 'renders a successful response' do
      post(moat_albums_path, params: { album: album_attributes }, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(Moat::CreateAlbumService).to have_received(:call).once
      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    before do
      allow(Moat::RemoveAlbumService).to receive(:call).and_return(successful_response)
    end

    context 'when its rendered a unauthorized response' do
      it 'the user is not admin' do
        delete(moat_album_path(album.id), headers: headers_credentials, as: :json)
        expect(response.body.blank?).to be(true)
        expect(Moat::RemoveAlbumService).not_to have_received(:call)
        expect(response).to be_unauthorized
      end
    end

    context 'when its rendered a successful response' do
      before do
        allow(Moat::RemoveAlbumService).to receive(:call).and_return(successful_response)
      end

      it 'the user is admin' do
        delete(moat_album_path(album.id), headers: admin_headers_credentials, as: :json)
        expect(response.body).to eq successful_body_content
        expect(Moat::RemoveAlbumService).to have_received(:call).once
        expect(response).to be_successful
      end
    end
  end
end
