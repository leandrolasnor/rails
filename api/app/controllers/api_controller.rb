# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:not_found, :health]

  rescue_from StandardError, with: :error
  rescue_from CanCan::AccessDenied, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def deny_access
    render body: nil, status: :unauthorized
  end

  def not_found
    render body: nil, status: :not_found
  end

  def health
    render body: 'I am here!', status: :ok
  end

  def error(error)
    Rails.logger.error(error)
    render body: nil, status: :internal_server_error
  end

  def parameter_missing(error)
    Rails.logger.error(error)
    render body: nil, status: :bad_request
  end

  def pagination_params
    {
      pagination: {
        current_page: request.headers['current-page'] || 1,
        per_page: request.headers['per-page'] || 10
      }
    }
  end

  def search_pagination_params
    limit = request.headers.fetch('per-page', 10).to_i
    current_page = request.headers.fetch('current-page', 1).to_i
    offset = (current_page - 1) * limit
    { pagination: { limit: limit, offset: offset } }
  end

  def channel_params
    { channel: request.headers['client'] }
  end

  def deliver(content:, status:)
    render json: content, status: status
  end
end
