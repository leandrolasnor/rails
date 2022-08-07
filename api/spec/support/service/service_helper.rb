# frozen_string_literal: true

module Service
  def successful_body_content
    { code: 0, message: 'ok' }.to_json
  end

  def successful_response
    { content: { code: 0, message: 'ok' }, status: :ok }
  end

  def unsuccessful_response
    { content: { code: -1, message: 'failure' }, status: :internal_server_error }
  end
end
