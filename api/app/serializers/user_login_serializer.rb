# frozen_string_literal: true

class UserLoginSerializer < ActiveModel::Serializer
  attributes :email, :name, :role, :ws_token

  def ws_token
    @instance_options[:ws_token]
  end
end
