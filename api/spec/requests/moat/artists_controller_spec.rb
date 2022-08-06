# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArtistsController, type: :request do
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe 'GET /list' do
    before do
      allow(GetArtistsService).to receive(:call).and_return({ content: { code: 0, message: 'ok' }, status: :ok })
    end

    it 'renders a successful response' do
      get(artists_path, headers: headers_credentials, as: :json)
      expect(response.body).to eq successful_body_content
      expect(GetArtistsService).to have_received(:call).once
      expect(response).to be_successful
    end
  end
end
