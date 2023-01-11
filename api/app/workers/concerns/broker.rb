# frozen_string_literal: true

module Broker
  extend ActiveSupport::Concern

  def broker(channel)
    ActionCable.server.broadcast(channel, yield)
  end
end
