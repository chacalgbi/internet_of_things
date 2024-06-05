class Notification < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[identity channel created_at recipient id message result updated_at]
  end
end
