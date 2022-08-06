# frozen_string_literal: true

class SearchAlbumsService < ApplicationService
  def call
    params[:query] = sanitize do
      ['LOWER(name) like ?', "%#{params[:query]}%"]
    end
    HandleSearchAlbumsWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
