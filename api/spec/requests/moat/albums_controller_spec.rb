# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::AlbumsController do
  let(:album) { create(:album) }
  let(:headers_credentials) do
    {
      uid: sign_in_common_user.dig(:headers, 'uid'),
      client: sign_in_common_user.dig(:headers, 'client'),
      'access-token': sign_in_common_user.dig(
        :headers,
        'access-token'
      )
    }
  end
  let(:admin_headers_credentials) do
    {
      uid: sign_in_admin_user.dig(:headers, 'uid'),
      client: sign_in_admin_user.dig(:headers, 'client'),
      'access-token': sign_in_admin_user.dig(
        :headers, 'access-token'
      )
    }
  end

  describe 'GET /show' do
    let(:album_show_params) do
      {
        id: album.id.to_s,
        channel: headers_credentials[:client]
      }.deep_stringify_keys!
    end

    before do
      allow(
        Moat::HandleShowAlbumWorker
      ).to receive(:perform_async).with(album_show_params)
      get(
        moat_album_path(album.id),
        headers: headers_credentials, as: :json
      )
    end

    it 'must to response successful way' do
      expect(response).to be_successful
      expect(json_body).to eq(successful_body_content)
      expect(
        Moat::HandleShowAlbumWorker
      ).to have_received(:perform_async).with(album_show_params)
    end
  end

  describe 'GET /search' do
    let(:query) { 'query' }
    let(:album_search_params) do
      {
        query: query,
        channel: headers_credentials[:client],
        pagination: {
          limit: 10,
          offset: 0
        }
      }.deep_stringify_keys!
    end

    before do
      allow(
        Moat::HandleSearchAlbumsWorker
      ).to receive(:perform_async).with(album_search_params)
      get(
        moat_albums_search_path(query: query),
        headers: headers_credentials, as: :json
      )
    end

    it 'must to response successful way' do
      expect(response).to be_successful
      expect(json_body).to eq(successful_body_content)
      expect(
        Moat::HandleSearchAlbumsWorker
      ).to have_received(:perform_async).with(album_search_params)
    end
  end

  describe 'PUT /update' do
    let(:name) { 'some other name' }
    let(:params) do
      {
        name: name
      }
    end
    let(:album_update_params) do
      {
        id: album.id.to_s,
        name: name,
        channel: headers_credentials[:client]
      }.deep_stringify_keys!
    end

    before do
      allow(
        Moat::HandleUpdateAlbumWorker
      ).to receive(:perform_async).with(album_update_params)
      put(
        moat_album_path(album.id),
        params: { album: params },
        headers: headers_credentials, as: :json
      )
    end

    it 'must to response successful way' do
      expect(response).to be_successful
      expect(json_body).to eq(successful_body_content)
      expect(
        Moat::HandleUpdateAlbumWorker
      ).to have_received(:perform_async).with(album_update_params)
    end
  end

  describe 'POST /create' do
    let(:params) do
      {
        name: 'some name',
        year: 1991,
        artist_id: 1
      }
    end
    let(:album_create_params) do
      params.merge(
        channel: headers_credentials[:client]
      ).deep_stringify_keys!
    end

    before do
      allow(
        Moat::HandleCreateAlbumWorker
      ).to receive(:perform_async).with(album_create_params)
      post(
        moat_albums_path,
        params: { album: params },
        headers: headers_credentials, as: :json
      )
    end

    it 'must to response successful way' do
      expect(response).to be_successful
      expect(json_body).to eq(successful_body_content)
      expect(
        Moat::HandleCreateAlbumWorker
      ).to have_received(:perform_async).with(album_create_params)
    end
  end

  describe 'DELETE /destroy' do
    context 'when user have authorization' do
      let(:album_destroy_params) do
        {
          id: album.id.to_s,
          channel: admin_headers_credentials[:client]
        }
      end

      before do
        allow(
          Moat::HandleRemoveAlbumWorker
        ).to receive(:perform_async).with(album_destroy_params)
        delete(
          moat_album_path(album.id),
          headers: admin_headers_credentials, as: :json
        )
      end

      it 'must to response successful way' do
        expect(response).to be_successful
        expect(json_body).to eq successful_body_content
        expect(
          Moat::HandleRemoveAlbumWorker
        ).to have_received(:perform_async).with(album_destroy_params)
      end
    end

    context 'when user have not authorization' do
      let(:album_destroy_params) do
        {
          id: album.id,
          channel: headers_credentials[:client]
        }
      end

      before do
        allow(
          Moat::HandleRemoveAlbumWorker
        ).to receive(:perform_async).with(album_destroy_params)
        delete(
          moat_album_path(album.id),
          headers: headers_credentials, as: :json
        )
      end

      it 'must to response unauthorized way' do
        expect(response).to be_unauthorized
        expect(json_body).to be_nil
        expect(
          Moat::HandleRemoveAlbumWorker
        ).not_to have_received(:perform_async).with(album_destroy_params)
      end
    end
  end
end
