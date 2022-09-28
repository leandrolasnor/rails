# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Api::Artist, type: :module do
  subject(:moat) { described_class }

  let(:call) { moat.all }
  let(:moat_url) { ENV.fetch('MOAT_URI') }
  let(:moat_headers) { { 'Basic' => Rails.application.credentials.dig(:moat, :token) } }

  skip 'when .all bring a response code equal 200' do
    let(:moat_response) { instance_double(HTTParty::Response, body: moat_response_body, code: 200) }
    let(:moat_response_body) do
      [
        { id: 1, name: 'Artist1', twitter: '@Artist1' },
        { id: 2, name: 'Artist2', twitter: '@Artist2' }
      ]
    end

    before do
      allow(HTTParty).to receive(:get).and_return(moat_response)
      allow(JSON).to receive(:parse).and_return(instance_double(flatten: moat_response_body))
      call
    end

    it 'fetches the artists from Moat api' do
      expect(HTTParty).to have_received(:get).with(moat_url, headers: moat_headers)
    end

    it 'parses the Moat response' do
      expect(JSON).to have_received(:parse).with(moat_response_body, symbolize_names: true)
    end
  end

  skip 'when .all bring a response code is not equal 200' do
    let(:moat_response) { instance_double(HTTParty::Response, body: '400 Bad Request', code: 400) }

    let(:log_message) { { from: 'Moat::Artist.all', code: moat_response.code, body: moat_response.body } }

    before do
      allow(HTTParty).to receive(:get).and_return(moat_response)
      allow(Rails.logger).to receive(:error)
      call
    end

    it 'the result is a empty array' do
      expect(call).to eq([])
    end

    it 'try fetches the artists from Moat api' do
      expect(HTTParty).to have_received(:get).with(moat_url, headers: moat_headers)
    end

    it 'write in log the response result' do
      expect(Rails.logger).to have_received(:error).with(log_message)
    end
  end
end
