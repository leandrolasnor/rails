# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::HandleUpdateAlbumWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: 'channel' } }
  let(:error) { StandardError.new('Some Error') }
  let(:event_error) do
    {
      type: '500',
      payload: {
        message: I18n.t(:message_internal_server_error)
      }
    }
  end

  context 'when there is a success case' do
    let(:event_success) do
      {
        type: 'ALBUM_UPDATED',
        payload: { album: 'album updated' }
      }
    end

    before do
      allow_any_instance_of(Moat::Album).to receive(:artist).and_return({})
      allow(Moat::Albums).
        to receive(:update).
        with(params).
        and_yield('album updated', nil)
      allow(ActionCable.server).
        to receive(:broadcast).
        with(params[:channel], event_success)
      worker
    end

    it 'the Albums module is called once with correct params' do
      expect(Moat::Albums).to have_received(:update).with(params)
      expect(ActionCable.server).
        to have_received(:broadcast).
        with(params[:channel], event_success)
    end
  end

  context 'when there is a failure case' do
    let(:event_failure) do
      {
        type: 'ERRORS_FROM_ALBUM_UPDATED',
        payload: { errors: ['error'] }
      }
    end

    before do
      allow_any_instance_of(Moat::Album).to receive(:artist).and_return({})
      allow(Moat::Albums).
        to receive(:update).
        with(params).and_yield(nil, ['error'])
      allow(ActionCable.server).
        to receive(:broadcast).
        with(params[:channel], event_failure)
      worker
    end

    it 'the Albums module is called once with incorrect params' do
      expect(Moat::Albums).to have_received(:update).with(params).once
      expect(ActionCable.server).
        to have_received(:broadcast).
        with(params[:channel], event_failure).once
    end
  end

  context 'when to raise a error' do
    before do
      allow(Moat::Albums).to receive(:update).with(params).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error)
      allow(ActionCable.server).
        to receive(:broadcast).
        with(params[:channel], event_error)
      worker
    end

    it 'the rescue block will to run' do
      expect(Rails.logger).to have_received(:error).with(error)
      expect(ActionCable.server).
        to have_received(:broadcast).
        with(params[:channel], event_error)
    end
  end
end
