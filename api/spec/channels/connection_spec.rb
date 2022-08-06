require "rails_helper"
require 'json'

RSpec.describe ApplicationCable::Connection, type: [:channel, :request, :controller, :feature] do

  context "must be connected" do
    let(:sign_in_response) { sign_in }
    it "when send connection params" do
      connect "/cable?ws_token=#{sign_in_response[:body][:ws_token]}"
      expect(connection.client).to eq sign_in_response[:headers]['client']
    end
  end

  context "must be disconected" do
    it "when connect was reject" do
      expect { connect "/cable" }.to have_rejected_connection
    end
  end

end