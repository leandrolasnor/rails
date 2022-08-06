require 'rails_helper'

RSpec.describe SearchAlbumsService, type: :service do
  
  context "calling service" do
    context "with query param" do
      let(:params) {{query: 'some albums name'}}
      let(:service) { described_class.call(params) }
      
      before do
        allow(HandleSearchAlbumsWorker).to receive(:perform_async).with(params)
      end
  
      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(HandleSearchAlbumsWorker).to have_received(:perform_async).with(params).once
      end
    end

    context "withou query param" do
      let(:params) {{query: "LOWER(name) like '%%'"}}
      let(:service) { described_class.call({}) }
      
      before do
        allow(HandleSearchAlbumsWorker).to receive(:perform_async).with(params)
      end
  
      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(HandleSearchAlbumsWorker).to have_received(:perform_async).with(params).once
      end
    end

    context "and rescue a error" do
      let(:params) {{query: "LOWER(name) like '%%'"}}
      let(:error){StandardError.new("Error")}
      let(:service) { described_class.call({}) }
      
      before do
        allow(Rails.logger).to receive(:error).with(error.inspect)
        allow(HandleSearchAlbumsWorker).to receive(:perform_async).with(params).and_raise(error)
      end
      
      it "but did can to handle" do
        expect(service).to eq(unsuccessful_response)
        expect(Rails.logger).to have_received(:error).with(error.inspect).once
      end
    end
  end
end