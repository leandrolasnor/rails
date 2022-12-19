# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::HandleSearchAlbumsWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: 'channel' } }
  let(:error) { StandardError.new('Some Error') }
  let(:event_error) { { type: '500', payload: { message: I18n.t(:message_internal_server_error) } } }

  context 'when there is a success case' do
    let(:event_success) { { type: 'ALBUMS_FETCHED', payload: { albums: ['albums'] } } }

    before do
      allow(Moat::Albums).to receive(:search).with(params).and_yield(['albums'], nil)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it 'the Albums module is called once with correct params' do
      expect(Moat::Albums).to have_received(:search).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context 'when there is a failure case' do
    let(:event_failure) { { type: 'ERRORS_FROM_SEARCH_ALBUMS', payload: { errors: ['errors'] } } }

    before do
      allow(Moat::Albums).to receive(:search).with(params).and_yield(nil, ['errors'])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it 'the Albums module is called once with incorrect params' do
      expect(Moat::Albums).to have_received(:search).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end

  context 'when there is a rescue case' do
    before do
      allow(Moat::Albums).to receive(:search).with(params).and_raise(error)
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
