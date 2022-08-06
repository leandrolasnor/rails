# frozen_string_literal: true

module ::ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :client

    def connect
      ws_token = request.original_fullpath.sub('/cable?ws_token=', '')
      user_params = crypt.decrypt_and_verify(ws_token)
      uid           = user_params[:uid]
      client        = user_params[:client]
      access_token  = user_params[:access_token]
      self.client = client if authentic(access_token, uid, client)
    rescue StandardError => error
      Rails.logger.error(error.message)
      reject_unauthorized_connection
    end

    protected

    # this checks whether a user is authenticated with devise
    def authentic(token, uid, client_id)
      user = User.find_by(email: uid)
      user&.valid_token?(token, client_id)
    end

    def crypt
      @crypt ||= ActiveSupport::MessageEncryptor.new(Rails.application.credentials[:secret_key_base][0..31])
    end
  end
end
