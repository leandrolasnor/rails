# frozen_string_literal: true

class ApplicationService
  private_class_method :new

  def self.call(params = nil)
    new(params).call
  end

  def initialize(params = nil)
    params = params.to_h if params.respond_to?(:to_h)
    @params = params
    @handle_response = { content: { code: 0, message: 'ok' }, status: :ok }
    @error_response = { content: { code: -1, message: 'failure' }, status: :internal_server_error }
  end

  def call; end

  private

  attr_accessor :handle_response
  attr_accessor :error_response
  attr_reader :params
end
