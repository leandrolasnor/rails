# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::CreateAlbumService, type: :service do
  describe '.call' do
    context 'on success' do
      let(:params) do
        {
          name: Faker::Games::Pokemon.name,
          year: rand(1948..Time.zone.now.year),
          artist_id: [1, 2, 3, 4, 5].sample
        }
      end
      let(:service) { described_class.call(params) }

      before do
        allow(
          Moat::HandleCreateAlbumWorker
        ).to receive(:perform_async).with(params)
      end

      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(
          Moat::HandleCreateAlbumWorker
        ).to have_received(:perform_async).with(params)
      end
    end

    context 'on exception' do
      context 'when StandardError' do
        let(:error) { StandardError.new('Error') }
        let(:params) do
          {
            name: Faker::Games::Pokemon.name,
            year: rand(1948..Time.zone.now.year),
            artist_id: [1, 2, 3, 4, 5].sample
          }
        end
        let(:service) { described_class.call(params) }

        before do
          allow(Rails.logger).to receive(:error).with(error)
          allow(
            Moat::HandleCreateAlbumWorker
          ).to receive(:perform_async).with(params).and_raise(error)
        end

        it 'but did can to handle' do
          expect(service).to eq(unsuccessful_response)
          expect(Rails.logger).to have_received(:error).with(error)
        end
      end
    end
  end
end
