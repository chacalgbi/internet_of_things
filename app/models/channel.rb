# frozen_string_literal: true

class Channel < ApplicationRecord
  validates :client_id, presence: true
  validates :device_id, presence: true
  validates :category, presence: true, length: { minimum: 3 }
  validates :path, presence: true, length: { minimum: 3 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[array_info category client_id color created_at device_id id id_value label obs path platform previous_state
       range tipo updated_at]
  end
end
