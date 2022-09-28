# frozen_string_literal: true

module ::Latech
  class Address < ApplicationRecord
    self.abstract_class = true

    has_many :address_assignments, inverse_of: :address, dependent: :destroy
    has_many :users, through: :address_assignments

    delegate :capture, to: :cepla

    validates :address, presence: true
    validates :district, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip, format: { with: /([0-9])\d{7}/ }

    default_scope { order(address: :asc) }

    private

    def cepla
      @cepla ||= Latech::Cepla::Address.new(self)
    end
  end
end
