# frozen_string_literal: true

module Service
  attr_writer :successful_body_content
  attr_writer :successful_response
  attr_writer :unsuccessful_response

  def successful_body_content
    @successful_body_content ||= { code: 0, message: 'ok' }
  end

  def successful_response
    @successful_response ||= {
      content: {
        code: 0,
        message: 'ok'
      },
      status: :ok
    }
  end

  def unsuccessful_response
    @unsuccessful_response ||= {
      content: {
        code: -1,
        message: 'failure'
      },
      status: :internal_server_error
    }
  end
end
