# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::SearchAlbumsService, type: :service do
  context 'when calling the service' do
    let(:params) { { query: 'some albums name' } }
    let(:params_worker) { { query: 'some albums name' } }
    let(:service) { described_class.call(params) }

    before do
      allow(
        Moat::HandleSearchAlbumsWorker
      ).to receive(:perform_async).with(params_worker)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(
        Moat::HandleSearchAlbumsWorker
      ).to have_received(:perform_async).with(params_worker)
    end

    context 'when rescue a StandardError' do
      let(:error) { StandardError.new('Error') }
      let(:service) { described_class.call(params) }

      before do
        allow(Rails.logger).to receive(:error).with(error)
        allow(
          Moat::HandleSearchAlbumsWorker
        ).to receive(:perform_async).with(params_worker).and_raise(error)
      end

      it "it's can to deal" do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
