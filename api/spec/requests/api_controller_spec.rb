# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let(:address) { create(:address) }
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe 'GET /not_found' do
    context 'when route is not found' do
      before do
        get('/not_found', headers: headers_credentials, as: :json)
      end

      it 'renders a unsuccessful response' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_blank
      end
    end
  end

  describe 'GET /' do
    context 'when root route is found' do
      before do
        get(root_path, as: :json)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
        expect(response.body).to eq('I am here!')
      end
    end
  end
end
