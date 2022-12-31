# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Artist, type: :module do
  skip '.all' do
    let(:url) { ENV.fetch('MOAT_URI') }
    let(:headers) { { 'Basic' => Rails.application.credentials.dig(:moat, :token) } }

    context 'when response code is 200' do
      let(:response) { instance_double(HTTParty::Response, body: response_body, code: 200) }
      let(:response_body) do
        [
          { id: 1, name: 'Artist1', twitter: '@Artist1' },
          { id: 2, name: 'Artist2', twitter: '@Artist2' }
        ]
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response)
        allow(JSON).to receive(:parse).and_return(instance_double(flatten: response_body))
        described_class.all
      end

      it 'must to call HTTParty and JSON.parse' do
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
        expect(JSON).to have_received(:parse).with(response_body, symbolize_names: true)
      end
    end

    context 'when response code is not 200' do
      let(:response) { instance_double(HTTParty::Response, body: '400 Bad Request', code: 400) }
      let(:log_message) { { from: 'Moat::Artist.all', code: response.code, body: response.body } }
      let(:call) { described_class.all }

      before do
        allow(HTTParty).to receive(:get).and_return(response)
        allow(Rails.logger).to receive(:error)
        call
      end

      it 'must to call HTTParty and write error in log' do
        expect(call).to eq([])
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
        expect(Rails.logger).to have_received(:error).with(log_message)
      end
    end
  end
end
