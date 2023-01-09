# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::ArtistsController do
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

  describe 'GET /list' do
    let(:index_params) do
      {
        channel: headers_credentials[:client]
      }
    end

    before do
      allow(
        Moat::HandleGetArtistsWorker
      ).to receive(:perform_async).with(index_params)
      get(moat_artists_path, headers: headers_credentials, as: :json)
    end

    it 'renders a successful response' do
      expect(response).to be_successful
      expect(json_body).to eq successful_body_content
      expect(
        Moat::HandleGetArtistsWorker
      ).to have_received(:perform_async).with(index_params)
    end
  end
end
