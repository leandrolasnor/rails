# frozen_string_literal: true

module ::Api
  class Moat::Api::Album
    attr_reader :album

    def initialize(album)
      @album = album
    end

    def artist
      get_artist(album.artist_id)
    end

    private

    def get_artist(id)
      # response = HTTParty.get("#{uri}?artist_id=#{id}", headers: headers)
      # return JSON.parse(response.body, symbolize_names: true).first if response.code == 200
      # Rails.logger.error({ from: "Moat::Artist.find(#{id})", code: response.code, body: response.body })
      [
        { id: 1, name: 'Ed Sheeran', twitter: '@edsheeran' },
        { id: 2, name: 'Eminem', twitter: '@Eminem' },
        { id: 3, name: 'Maroon 5', twitter: '@maroon5' },
        { id: 4, name: 'Coldplay', twitter: '@coldplay' },
        { id: 5, name: 'Bruno Mars', twitter: '@BrunoMars' }
      ].detect { |artist| artist[:id] == id }
    end

    def uri
      ENV.fetch('MOAT_URI')
    end

    def headers
      { 'Basic' => Rails.application.credentials.dig(:moat, :token) }
    end
  end
end
