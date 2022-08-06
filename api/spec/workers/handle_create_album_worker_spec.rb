require 'rails_helper'

RSpec.describe HandleCreateAlbumWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: "channel" } }
  let(:error) { StandardError.new("Some Error") }
  let(:event_error) { {type: '500', payload:{message: 'HTTP 500 Internal Server Error'} } }
  
  context "when there is a success case" do
    let(:event_success) { {type: 'ALBUM_CREATED', payload:{ album: "album created" }} }
    before do
      allow(Albums).to receive(:create).with(params).and_yield("album created", nil)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_success)
      worker
    end

    it "the Albums module is called once with correct params" do
      expect(Albums).to have_received(:create).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_success).once
    end
  end

  context "when there is a failure case" do
    let(:event_failure) { {type: 'ERRORS_FROM_ALBUM_CREATED', payload:{errors: ["error1", "error2"]}} }
    before do
      allow(Albums).to receive(:create).with(params).and_yield(nil, ["error1", "error2"])
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_failure)
      worker
    end

    it "the Albums module is called once with incorrect params" do
      expect(Albums).to have_received(:create).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_failure).once
    end
  end

  context "when there is a rescue case" do
    before do
      allow(Albums).to receive(:create).with(params).and_raise(error)
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