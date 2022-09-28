# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::AddresesController, type: :request do
  let(:address) { create(:address) }
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe 'GET /search' do
    context 'with query param' do
      let(:address_search_params) do
        ActionController::Parameters.new({
          query: 'query',
          user_id: 1,
          channel: headers_credentials[:client],
          pagination: ActionController::Parameters.new({
            limit: 10,
            offset: 0
          })
        }).permit(
          :query,
          :user_id,
          :channel, {
            pagination: [
              :limit,
              :offset
            ]
          }
        )
      end

      before do
        allow(Latech::SearchAddresesService).to receive(:call).with(address_search_params).and_return(successful_response)
        get(latech_addreses_search_path(query: 'query'), headers: headers_credentials, as: :json)
      end

      it 'renders a successful response' do
        expect(response.body).to eq successful_body_content
        expect(Latech::SearchAddresesService).to have_received(:call).with(address_search_params).once
        expect(response).to be_successful
      end
    end

    context 'without query param' do
      let(:address_search_params) do
        ActionController::Parameters.new({
          query: '',
          user_id: 1,
          channel: headers_credentials[:client],
          pagination: ActionController::Parameters.new({
            limit: 10,
            offset: 0
          })
        }).permit(
          :query,
          :user_id,
          :channel, {
            pagination: [
              :limit,
              :offset
            ]
          }
        )
      end

      before do
        allow(Latech::SearchAddresesService).to receive(:call).with(address_search_params).and_return(successful_response)
        get(latech_addreses_search_path(query: ''), headers: headers_credentials, as: :json)
      end

      it 'renders a successful response' do
        expect(response.body).to eq successful_body_content
        expect(Latech::SearchAddresesService).to have_received(:call).with(address_search_params).once
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /capture' do
    let(:address_capture_params) do
      ActionController::Parameters.new({
        zip: '23058500',
        user_id: 1,
        channel: headers_credentials[:client]
      }).permit(:zip, :user_id, :channel)
    end

    before do
      allow(Latech::CaptureAddressService).to receive(:call).with(address_capture_params).and_return(successful_response)
      get(latech_addreses_capture_path(zip: 23058500), headers: headers_credentials, as: :json)
    end

    it 'renders a successful response' do
      expect(response.body).to eq successful_body_content
      expect(Latech::CaptureAddressService).to have_received(:call).with(address_capture_params).once
      expect(response).to be_successful
    end
  end
end
