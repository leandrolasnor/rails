# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::GetArtistsService, type: :service do
  context 'when calling service' do
    let(:service) { described_class.call }

    before do
      allow(Moat::HandleGetArtistsWorker).to receive(:perform_async)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(Moat::HandleGetArtistsWorker).to have_received(:perform_async).once
    end

    context 'when rescue a error' do
      let(:error) { StandardError.new('Error') }
      let(:service) { described_class.call }

      before do
        allow(Rails.logger).to receive(:error).with(error.message)
        allow(Moat::HandleGetArtistsWorker).to receive(:perform_async).and_raise(error)
      end

      it 'but did can to handle' do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error.message).once
      end
    end
  end
end
