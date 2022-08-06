require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  subject { ApiController.new }

  context "#not_found" do
    before do
      allow_any_instance_of(ApiController).to receive(:render).with(body: nil, status: :not_found)
      subject.not_found
    end
    
    it "is rendered" do
      expect(subject).to have_received(:render).with(body: nil, status: :not_found).once
    end
  end
  
  context "#health" do
    before do
      allow_any_instance_of(ApiController).to receive(:render).with(body: "I am here!", status: :ok)
      subject.health
    end
    
    it "is rendered" do
      expect(subject).to have_received(:render).with(body: "I am here!", status: :ok).once
    end
  end

  context "#error" do
    let(:error){ StandardError.new }
    before do
      allow(Rails.logger).to receive(:error).with(error.inspect)
      allow_any_instance_of(ApiController).to receive(:render).with(body: nil, status: :internal_server_error)
      subject.error(error)
    end
    
    it "is rendered" do
      expect(subject).to have_received(:render).with(body: nil, status: :internal_server_error).once
      expect(Rails.logger).to have_received(:error).with(error.inspect) 
    end
  end
end