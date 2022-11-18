# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Cepla::Http::Services::GetAddress, type: :context do
  let(:headers) { { accept: 'application/json' } }
  let(:url) { "#{ENV.fetch(LATECH_CEPLA_URI)}/#{zip}" }
  let(:zip) { 23058500 }
  let(:service) { described_class.call!(zip: zip) }

  context 'on success' do
    let(:response) { instance_double(HTTParty::Response, body: parsed_response.to_json, code: 200, parsed_response: parsed_response) }
    let(:parsed_response) { { cep: 23058500, uf: 'RJ', cidade: 'Rio de Janeiro', bairro: 'Cosmos', logradouro: 'Rua Aripuana' } }

    before do
      allow(HTTParty).to receive(:get).with(url, headers: headers).and_return(response)
    end

    it do
      expect(service == parsed_response.symbolize_keys).to be_truthy
      expect(HTTParty).to have_received(:get).with(url, headers: headers)
    end
  end

  context 'on error' do
    context 'on 400' do
      let(:response) { instance_double(HTTParty::Response, body: parsed_response.to_json, code: 400, parsed_response: parsed_response) }
      let(:parsed_response) { {} }

      before do
        allow(HTTParty).to receive(:get).with(url, headers: headers).and_return(response)
        allow(Rails.logger).to receive(:error).with({ from: "Latech::Cepla::Http::Services::GetAddress.call!(zip:#{zip})", code: response.code, body: response.body })
      end

      it do
        expect { service }.to raise_error(I18n.t(:error_on_http_service_from_address_capture))
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
        expect(Rails.logger).to have_received(:error).with({ from: "Latech::Cepla::Http::Services::GetAddress.call!(zip:#{zip})", code: response.code, body: response.body })
      end
    end
  end

  context 'on exception' do
    context 'on ArgumentError' do
      let(:zip) { nil }

      before do
        allow(HTTParty).to receive(:get).with(url, headers: headers)
      end

      it do
        expect { service }.to raise_error(ArgumentError)
        expect(HTTParty).not_to have_received(:get).with(url, headers: headers)
      end
    end

    context 'on HTTParty::Error' do
      let(:error) { HTTParty::Error.new('Some Error') }

      before do
        allow(HTTParty).to receive(:get).with(url, headers: headers).and_raise(error)
        allow(Rails.logger).to receive(:error).with(error.message)
      end

      it do
        expect { service }.to raise_error(HTTParty::Error)
        expect(Rails.logger).to have_received(:error).with(error.message)
      end
    end
  end
end
