# frozen_string_literal: true

module Moat::Api::Artist
  class << self
    def all
      # uri = ENV['MOAT_URI']
      # headers = {"Basic"  => Rails.application.credentials.dig(:moat, :token)}
      # response = HTTParty.get(uri, headers: headers)
      # return JSON.parse(response.body, symbolize_names: true).flatten if response.code == 200
      # Rails.logger.error({ from: "Moat::Artist.all", code: response.code, body: response.body })
      [
        { id: 1, name: 'Ed Sheeran', twitter: '@edsheeran' },
        { id: 2, name: 'Eminem', twitter: '@Eminem' },
        { id: 3, name: 'Maroon 5', twitter: '@maroon5' },
        { id: 4, name: 'Coldplay', twitter: '@coldplay' },
        { id: 5, name: 'Bruno Mars', twitter: '@BrunoMars' }
      ]
    end
  end
end
