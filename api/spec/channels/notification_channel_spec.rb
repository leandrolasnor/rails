# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationChannel, type: [:channel, :request] do
  describe 'subscription' do
    let(:client) { sign_in_common_user.dig(:headers, 'client') }

    context 'when send correctly connect params' do
      before do
        stub_connection client: client
        subscribe
      end

      it { expect(subscription).to be_confirmed }
    end

    context 'when send invalid connect params' do
      before do
        stub_connection client: nil
        subscribe
      end

      it { expect(subscription).not_to be_confirmed }
    end
  end
end
