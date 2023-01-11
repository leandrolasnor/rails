# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Cepla::Http::Services::GetAddress, type: :context do
  let(:headers) { { accept: 'application/json' } }
  let(:url) { "#{ENV.fetch('LATECH_CEPLA_URI')}/#{zip}" }
  let(:zip) { 23058500 }
  let(:service) { described_class.call!(zip: zip) }

  describe '.call!' do
    context 'on success' do
      let(:response) do
        instance_double(
          HTTParty::Response,
          body: parsed_response.to_json,
          code: 200,
          parsed_response: parsed_response
        )
      end
      let(:parsed_response) do
        {
          cep: 23058500,
          uf: 'RJ',
          cidade: 'Rio de Janeiro',
          bairro: 'Cosmos',
          logradouro: 'Rua Aripuana'
        }
      end

      before do
        allow(HTTParty).
          to receive(:get).
          with(url, headers: headers).
          and_return(response)
      end

      it 'must to return address data from external api' do
        expect(service).to eq(parsed_response.symbolize_keys)
        expect(HTTParty).to have_received(:get).with(url, headers: headers)
      end
    end

    context 'on error' do
      context 'when code is equal 400' do
        let(:response) do
          instance_double(
            HTTParty::Response,
            body: parsed_response.to_json,
            code: 400,
            parsed_response: parsed_response
          )
        end
        let(:parsed_response) { {} }
        let(:error) do
          {
            from: "::Http::Services::GetAddress.call!(zip:#{zip})",
            code: response.code,
            body: response.body
          }
        end

        before do
          allow(HTTParty).
            to receive(:get).
            with(url, headers: headers).
            and_return(response)
          allow(Rails.logger).
            to receive(:error).
            with(error)
        end

        it 'must to raise error_on_http_service_from_address_capture error' do
          expect { service }.
            to raise_error(
              StandardError,
              I18n.t(:error_on_http_service_from_address_capture)
            )
          expect(HTTParty).
            to have_received(:get).
            with(url, headers: headers)
          expect(Rails.logger).
            to have_received(:error).
            with(error)
        end
      end
    end

    context 'on exception' do
      context 'with ArgumentError' do
        let(:zip) { nil }

        before do
          allow(HTTParty).to receive(:get).with(url, headers: headers)
        end

        it 'must to raise a ArgumentError error' do
          expect { service }.to raise_error(ArgumentError)
          expect(HTTParty).
            not_to have_received(:get).
            with(url, headers: headers)
        end
      end

      context 'with HTTParty::Error' do
        let(:error) { HTTParty::Error.new('Some Error') }

        before do
          allow(HTTParty).
            to receive(:get).
            with(url, headers: headers).
            and_raise(error)
          allow(Rails.logger).
            to receive(:error).
            with(error)
        end

        it 'must to raise a HTTParty::Error' do
          expect { service }.to raise_error(HTTParty::Error)
          expect(Rails.logger).to have_received(:error).with(error)
        end
      end
    end
  end
end
