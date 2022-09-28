# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::HandleSearchAddresesWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: 'channel' } }

  context 'on success' do
    let(:event_success) { { type: 'ADDRESES_FETCHED', payload: ['addreses'] } }

    before do
      allow(Latech::Addreses).to receive(:search).with(params).and_yield(['addreses'], nil)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it 'the Addreses module is called once with correct params' do
      expect(Latech::Addreses).to have_received(:search).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context 'on error' do
    let(:event_failure) { { type: 'ERRORS_FROM_ADDRESES_FETCHED', payload: { errors: ['errors'] } } }

    before do
      allow(Latech::Addreses).to receive(:search).with(params).and_yield(nil, ['errors'])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it 'the Addreses module is called once with incorrect params' do
      expect(Latech::Addreses).to have_received(:search).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end

  context 'on exception' do
    let(:error) { StandardError.new('Some Error') }
    let(:event_error) { { type: '500', payload: { message: I18n.t(:message_internal_server_error) } } }

    before do
      allow(Latech::Addreses).to receive(:search).with(params).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error.message)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_error)
      worker
    end

    it 'rescuing expection' do
      expect(Rails.logger).to have_received(:error).with(error.message).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_error).once
    end
  end
end
