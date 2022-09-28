# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::HandleGetArtistsWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: 'channel' } }

  context 'when there is a success case' do
    let(:event_success) { { type: 'ARTISTS_FETCHED', payload: { artists: [] } } }

    before do
      allow(Moat::Api::Artist).to receive(:all).and_return([])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it 'the Moat::Api::Artist module is called once' do
      expect(Moat::Api::Artist).to have_received(:all).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context 'when there is a rescue case' do
    let(:error) { StandardError.new('Some Error') }
    let(:event_error) { { type: '500', payload: { message: I18n.t(:message_internal_server_error) } } }

    before do
      allow(Moat::Api::Artist).to receive(:all).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error.message)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_error)
      worker
    end

    it 'the rescue block will to run' do
      expect(Rails.logger).to have_received(:error).with(error.message).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_error).once
    end
  end
end
