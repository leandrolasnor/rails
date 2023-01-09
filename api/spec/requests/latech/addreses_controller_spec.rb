# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::AddresesController do
  let(:address) { create(:address) }
  let(:headers_credentials) do
    {
      uid: sign_in_common_user.dig(:headers, 'uid'),
      client: sign_in_common_user.dig(:headers, 'client'),
      'access-token': sign_in_common_user.dig(
        :headers, 'access-token'
      )
    }
  end

  describe 'GET /search' do
    context 'with query param' do
      let(:query) { 'query' }
      let(:address_search_params) do
        {
          query: query,
          user_id: common_user.id,
          channel: headers_credentials[:client],
          pagination: {
            limit: 10,
            offset: 0
          }
        }.deep_stringify_keys!
      end

      before do
        allow(
          Latech::HandleSearchAddresesWorker
        ).to receive(:perform_async).with(address_search_params)

        get(
          latech_addreses_search_path(query: query),
          headers: headers_credentials, as: :json
        )
      end

      it 'must to response successful way' do
        expect(response).to be_successful
        expect(json_body).to eq(successful_body_content)
        expect(
          Latech::HandleSearchAddresesWorker
        ).to have_received(:perform_async).with(address_search_params)
      end
    end

    context 'without query param' do
      let(:query) { '' }
      let(:address_search_params) do
        {
          query: query,
          user_id: common_user.id,
          channel: headers_credentials[:client],
          pagination: {
            limit: 10,
            offset: 0
          }
        }.deep_stringify_keys!
      end

      before do
        allow(
          Latech::HandleSearchAddresesWorker
        ).to receive(:perform_async).with(address_search_params)
        get(
          latech_addreses_search_path(query: query),
          headers: headers_credentials, as: :json
        )
      end

      it 'must to response successful way' do
        expect(response).to be_successful
        expect(json_body).to eq(successful_body_content)
        expect(
          Latech::HandleSearchAddresesWorker
        ).to have_received(:perform_async).with(address_search_params)
      end
    end
  end

  describe 'GET /capture' do
    let(:zip) { '23058500' }
    let(:address_capture_params) do
      {
        zip: zip,
        user_id: common_user.id,
        channel: sign_in_common_user.dig(:headers, 'client')
      }.deep_stringify_keys!
    end

    before do
      allow(
        Latech::HandleCaptureAddressWorker
      ).to receive(:perform_async).with(address_capture_params)

      get(
        latech_addreses_capture_path(zip: zip),
        headers: headers_credentials, as: :json
      )
    end

    it 'must to response successful way' do
      expect(response).to be_successful
      expect(json_body).to eq(successful_body_content.merge(payload: nil))
      expect(
        Latech::HandleCaptureAddressWorker
      ).to have_received(:perform_async).with(address_capture_params)
    end
  end
end
