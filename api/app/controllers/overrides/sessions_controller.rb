# frozen_string_literal: true

module ::Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    protected

    def render_create_success
      render(
        json: @resource,
        serializer: UserLoginSerializer,
        ws_token: ws_token,
        status: :ok
      )
    end

    def ws_token
      @ws_token ||= message_encryptor.encrypt_and_sign(data)
    end

    def data
      {
        uid:          @resource[:uid],
        access_token: @token.token,
        client:       @token.client
      }
    end

    def message_encryptor
      ActiveSupport::MessageEncryptor.new(secret_key_base)
    end

    def secret_key_base
      Rails.application.credentials[:secret_key_base][0..31]
    end
  end
end
