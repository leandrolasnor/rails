# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::CaptureAddressService, type: :service do
  let(:params) { { zip: 23058500, user_id: 1 } }
  let(:service) { described_class.call(params.deep_symbolize_keys!) }

  context 'when there isnt cached address' do
    let(:cache_key_address) { "cached_address/#{params[:zip]}" }

    context 'and HandleCaptureAddressWorker is called' do
      before do
        successful_response[:content][:payload] = nil
        allow(Latech::Address).to receive(:search).and_return({ hits: [] })
        allow(Latech::HandleCaptureAddressWorker).to receive(:perform_async).with(params)
      end

      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(Latech::HandleCaptureAddressWorker).to have_received(:perform_async).with(params).once
      end
    end

    context 'and a error was raised on call to HandleCaptureAddressWorker' do
      let(:error) { StandardError.new('Some error') }
      let(:cache_key_address) { "cached_address/#{params[:zip]}" }

      before do
        allow(Rails.cache).to receive(:fetch).with(cache_key_address, expire_in: 12.hours, skip_nil: true).and_return(nil)
        allow(Rails.logger).to receive(:error).with(error.message)
        allow(Latech::HandleCaptureAddressWorker).to receive(:perform_async).with(params).and_raise(error)
      end

      it 'but its can to deal' do
        expect(service).to eq unsuccessful_response
        expect(Rails.logger).to have_received(:error).with(error.message).once
      end
    end
  end

  context 'when there is cached address' do
    let(:cache_key_address) { "cached_address/#{params[:zip]}" }
    let(:cached_address) { { id: 0 } }

    context 'and HandleMakeSureAssignmentWorker is called' do
      before do
        successful_response[:content][:payload] = cached_address
        allow(Rails.cache).to receive(:fetch).with(cache_key_address, expire_in: 12.hours, skip_nil: true).and_return(cached_address)
        allow(Latech::HandleMakeSureAssignmentWorker).to receive(:perform_async).with(params.merge!(address_id: cached_address[:id]))
      end

      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(Latech::HandleMakeSureAssignmentWorker).to have_received(:perform_async).with(params.merge!(address_id: cached_address[:id])).once
      end
    end

    context 'on a error was raised on call to HandleMakeSureAssignmentWorker' do
      let(:error) { StandardError.new('Some error') }

      before do
        allow(Rails.cache).to receive(:fetch).with(cache_key_address, expire_in: 12.hours, skip_nil: true).and_return(cached_address)
        allow(Rails.logger).to receive(:error).with(error.message)
        allow(Latech::HandleMakeSureAssignmentWorker).to receive(:perform_async).with(params.merge!(address_id: cached_address[:id])).and_raise(error)
      end

      it 'but its can to deal' do
        expect(service).to eq unsuccessful_response
        expect(Rails.logger).to have_received(:error).with(error.message).once
      end
    end
  end
end
