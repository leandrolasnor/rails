# frozen_string_literal: true

class ApplicationService
  private_class_method :new

  attr_reader :params

  def self.call(params = nil)
    new(params).call
  end

  def initialize(params = nil)
    params = params.to_h if params.respond_to?(:to_h)
    @params ||= params
  end

  def call; end

  private

  def handle_response
    { content: { code: 0, message: 'ok' }, status: :ok }
  end

  def error_response(error)
    Rails.logger.error(error.inspect)
    { content: { code: -1, message: 'failure' }, status: :internal_server_error }
  end

  def sanitize
    ApplicationRecord.sanitize_sql_for_conditions(yield)
  end
end
