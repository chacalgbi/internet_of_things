# frozen_string_literal: true

class Config < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value updated_at version path_update]
  end
end
