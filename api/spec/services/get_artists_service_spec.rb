require 'rails_helper'

RSpec.describe GetArtistsService, type: :service do
  
  context "calling service" do
    let(:service) { described_class.call }
    
    before do
      allow(HandleGetArtistsWorker).to receive(:perform_async)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(HandleGetArtistsWorker).to have_received(:perform_async).once
    end

    context "and rescue a error" do
      let(:error){StandardError.new("Error")}
      let(:service) { described_class.call }
      
      before do
        allow(Rails.logger).to receive(:error).with(error.inspect)
        allow(HandleGetArtistsWorker).to receive(:perform_async).and_raise(error)
      end
      
      it "but did can to handle" do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error.inspect).once
      end
    end
  end
end