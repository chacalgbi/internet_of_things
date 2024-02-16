class LogRegistry < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id classe updated_at classe_error message level backtrace params]
  end
end
