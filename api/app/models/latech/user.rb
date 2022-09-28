# frozen_string_literal: true

class Latech::User < User
  has_many :address_assignments, inverse_of: :user, dependent: :destroy
  has_many :addreses, through: :address_assignments
end
