# frozen_string_literal: true

class Device < ApplicationRecord
  # belongs_to :client
  # has_many :channels, dependent: :destroy

  validates :description, presence: true, length: { minimum: 3 }
  validates :device, presence: true, length: { minimum: 3 }
  validates :token, presence: true, length: { minimum: 5 }, uniqueness: { case_sensitive: false }
  validates :pathUpdate, presence: true, length: { minimum: 10 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[client_id created_at description device id linkAjuda obs pathUpdate tipo token updated_at versao configs devedor]
  end
end
