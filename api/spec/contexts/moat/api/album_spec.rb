# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Api::Album, type: :context do
  skip '.artist' do
    let(:album) { create(:album) }
    let(:moat) { described_class.new(album) }
    let(:call) { moat.artist }
    let(:url) { "#{ENV.fetch('MOAT_URI')}?artist_id=#{album.artist_id}" }
    let(:token) { Rails.application.credentials.dig(:moat, :token) }
    let(:headers) { { 'Basic' => token } }

    context 'when response code is 200' do
      let(:response) do
        instance_double(
          HTTParty::Response,
          body: response_body,
          code: 200
        )
      end
      let(:response_body) do
        {
          id: album.artist_id,
          name: 'Artist',
          twitter: '@Artist'
        }
      end

      before do
        allow(HTTParty).
          to receive(:get).
          with(url, headers: headers).
          and_return(response)
        allow(JSON).
          to receive(:parse).
          and_return(instance_double(first: response_body))
        call
      end

      it 'must to call HTTParty and JSON parse' do
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
        expect(JSON).
          to have_received(:parse).
          with(response_body, symbolize_names: true)
      end
    end

    context 'when response code is not 200' do
      let(:response) do
        instance_double(
          HTTParty::Response,
          body: '400 Bad Request',
          code: 400
        )
      end
      let(:log_message) do
        {
          from: "Moat::Artist.find(#{album.artist_id})",
          code: response.code,
          body: response.body
        }
      end

      before do
        allow(HTTParty).
          to receive(:get).
          with(url, headers: headers).
          and_return(response)
        allow(Rails.logger).to receive(:error)
        call
      end

      it 'must to call HTTParty and write error in log' do
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
        expect(Rails.logger).to have_received(:error).with(log_message)
      end
    end
  end
end
