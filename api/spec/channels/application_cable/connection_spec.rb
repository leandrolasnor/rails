# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: [:channel, :request] do
  context 'on connect' do
    let(:ws_token) { sign_in_common_user.dig(:body, :ws_token) }
    let(:client) { sign_in_common_user.dig(:headers, 'client') }

    it 'when send connection params' do
      connect "/cable?ws_token=#{ws_token}"
      expect(connection.client).to eq client
    end
  end

  context 'on disconect' do
    it 'when connect was reject' do
      expect { connect('/cable') }.to have_rejected_connection
    end
  end
end
