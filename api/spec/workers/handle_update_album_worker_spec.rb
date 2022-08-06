require 'rails_helper'

RSpec.describe HandleUpdateAlbumWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: "channel" } }
  let(:error) { StandardError.new("Some Error") }
  let(:event_error) { {type: '500', payload:{message: 'HTTP 500 Internal Server Error'} } }
  
  context "when there is a success case" do
    let(:event_success) { {type: 'ALBUM_UPDATED', payload:{ album: "album updated"}} }
    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
      allow(Albums).to receive(:update).with(params).and_yield("album updated", nil)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it "the Albums module is called once with correct params" do
      expect(Albums).to have_received(:update).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context "when there is a failure case" do
    let(:event_failure) { {type: 'ERRORS_FROM_ALBUM_UPDATED', payload:{errors: ["error"]}} }
    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
      allow(Albums).to receive(:update).with(params).and_yield(nil, ["error"])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it "the Albums module is called once with incorrect params" do
      expect(Albums).to have_received(:update).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end


  context "when there is a rescue case" do
    before do
      allow(Albums).to receive(:update).with(params).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error.inspect)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_error)
      worker
    end
    
    it "the rescue block will to run" do
      expect(Rails.logger).to have_received(:error).with(error.inspect).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_error).once
    end  
  end
end