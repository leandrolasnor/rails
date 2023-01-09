# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::UpdateAlbumService, type: :service do
  context 'when calling service' do
    let(:params) { { id: 1 } }
    let(:service) { described_class.call(params) }

    before do
      allow(
        Moat::HandleUpdateAlbumWorker
      ).to receive(:perform_async).with(params)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(
        Moat::HandleUpdateAlbumWorker
      ).to have_received(:perform_async).with(params)
    end

    context 'when rescue a StandardError' do
      let(:error) { StandardError.new('Error') }
      let(:service) { described_class.call(params) }

      before do
        allow(Rails.logger).to receive(:error).with(error)
        allow(
          Moat::HandleUpdateAlbumWorker
        ).to receive(:perform_async).with(params).and_raise(error)
      end

      it 'but did can to handle' do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
