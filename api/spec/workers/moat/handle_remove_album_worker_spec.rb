# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::HandleRemoveAlbumWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:error) { StandardError.new('Some Error') }
  let(:event_error) { { type: '500', payload: { message: I18n.t(:message_internal_server_error) } } }

  context 'when there is a success case' do
    let(:album) { create(:album) }
    let(:params) { { channel: 'channel', id: album.id } }
    let(:event_success) { { type: 'ALBUM_REMOVED', payload: { album: Moat::AlbumSerializer.new(album).serializable_hash } } }

    before do
      allow_any_instance_of(Moat::Album).to receive(:artist).and_return({})
      allow(Moat::Albums).to receive(:delete).with(params).and_yield(Moat::AlbumSerializer.new(album).serializable_hash, nil)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it 'the Albums module is called once with correct params' do
      expect(Moat::Albums).to have_received(:delete).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context 'when there is a failure case' do
    let(:params) { { channel: 'channel', id: 9999 } }
    let(:event_failure) { { type: 'ERRORS_FROM_ALBUM_REMOVED', payload: { errors: ["Couldn't find Moat::Album with 'id'=9999"] } } }

    before do
      allow_any_instance_of(Moat::Album).to receive(:artist).and_return({})
      allow(Moat::Albums).to receive(:delete).with(params).and_yield(nil, ["Couldn't find Moat::Album with 'id'=9999"])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it 'the Albums module is called once with incorrect params' do
      expect(Moat::Albums).to have_received(:delete).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end

  context 'when there is a rescue case' do
    let(:params) { { channel: 'channel', id: 9999 } }

    before do
      allow(Moat::Albums).to receive(:delete).with(params).and_raise(error)
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
