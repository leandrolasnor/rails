# frozen_string_literal: true

class Nexoos::User < User
  has_many :loans, class_name: 'Nexoos::Loans', inverse_of: :user, dependent: :destroy
end
