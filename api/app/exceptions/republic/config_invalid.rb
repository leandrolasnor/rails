# frozen_string_literal: true

module ::Republic
  class ConfigInvalid < StandardError
    attr_reader :message

    def initialize(msg = '', _type = '')
      @message = msg
    end
  end
end
