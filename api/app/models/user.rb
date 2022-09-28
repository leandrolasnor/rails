# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: { user: 0, admin: 1 }
  liberal_enum :role

  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :password_confirmation, presence: true, if: -> { password.present? }
end
