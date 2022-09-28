# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::HandleMakeSureAssignmentWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: 'channel' } }

  context 'on error' do
    let(:event_failure) { { type: 'ERRORS_FROM_MAKE_SURE_ASSIGNMENT', payload: { errors: ['errors'] } } }

    before do
      allow(Latech::Addreses).to receive(:make_sure_assignment).with(params).and_yield(nil, ['errors'])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it 'the Addreses module is called once with incorrect params' do
      expect(Latech::Addreses).to have_received(:make_sure_assignment).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end

  context 'on exception' do
    let(:error) { StandardError.new('Some Error') }
    let(:event_error) { { type: '500', payload: { message: I18n.t(:message_internal_server_error) } } }

    before do
      allow(Latech::Addreses).to receive(:make_sure_assignment).with(params).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error.message)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_error)
      worker
    end

    it 'rescuing exception' do
      expect(Rails.logger).to have_received(:error).with(error.message).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_error).once
    end
  end
end
