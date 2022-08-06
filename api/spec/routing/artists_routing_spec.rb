require "rails_helper"

RSpec.describe ArtistsController, type: :routing do
  describe "routing" do

    it "route to #artists" do
      expect(get: "/artists").to route_to("artists#list")
    end
  end
end
