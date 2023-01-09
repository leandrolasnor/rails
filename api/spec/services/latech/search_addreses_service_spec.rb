# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::SearchAddresesService, type: :service do
  context 'when calling the service' do
    let(:params) { { query: 'some address' } }
    let(:service) { described_class.call(params) }

    context 'on success' do
      before do
        allow(
          Latech::HandleSearchAddresesWorker
        ).to receive(:perform_async).with(params)
      end

      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(
          Latech::HandleSearchAddresesWorker
        ).to have_received(:perform_async).with(params)
      end
    end

    context 'on error' do
      let(:error) { StandardError.new('Error') }

      before do
        allow(Rails.logger).to receive(:error).with(error)
        allow(
          Latech::HandleSearchAddresesWorker
        ).to receive(:perform_async).with(params).and_raise(error)
      end

      it 'StandardError is raised and rescued' do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
