# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    reject if client.nil?
    stream_from(client)
  end
end
