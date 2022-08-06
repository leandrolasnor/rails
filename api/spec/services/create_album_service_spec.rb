require 'rails_helper'

RSpec.describe CreateAlbumService, type: :service do
  
  context "calling service" do
    let(:params) {
      {
        name: Faker::Games::Pokemon.name,
        year: rand(1948..Time.now.year),
        artist_id: [1,2,3,4,5].sample
      }
    }
    let(:service) { described_class.call(params) }
    
    before do
      allow(HandleCreateAlbumWorker).to receive(:perform_async).with(params)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(HandleCreateAlbumWorker).to have_received(:perform_async).with(params).once
    end

    context "and rescue a error" do
      let(:error){StandardError.new("Error")}
      let(:params) {
        {
          name: Faker::Games::Pokemon.name,
          year: rand(1948..Time.now.year),
          artist_id: [1,2,3,4,5].sample
        }
      }
      let(:service) { described_class.call(params) }
      
      before do
        allow(Rails.logger).to receive(:error).with(error.inspect)
        allow(HandleCreateAlbumWorker).to receive(:perform_async).with(params).and_raise(error)
      end
      
      it "but did can to handle" do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error.inspect).once
      end
    end
  end
end