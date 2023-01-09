# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::RemoveAlbumService, type: :service do
  context 'when calling the service' do
    let(:params) { { id: 1 } }
    let(:service) { described_class.call(params) }

    before do
      allow(
        Moat::HandleRemoveAlbumWorker
      ).to receive(:perform_async).with(params)
    end

    it 'must to return successful response' do
      expect(service).to eq successful_response
      expect(
        Moat::HandleRemoveAlbumWorker
      ).to have_received(:perform_async).with(params)
    end

    context 'when rescue a StandardError' do
      let(:error) { StandardError.new('Error') }

      before do
        allow(Rails.logger).to receive(:error).with(error)
        allow(
          Moat::HandleRemoveAlbumWorker
        ).to receive(:perform_async).with(params).and_raise(error)
      end

      it "it's can to deal" do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error)
      end
    end
  end
end
