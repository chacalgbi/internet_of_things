class Client < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[address_mqtt cel created_at email id id_value name obs updated_at]
  end
end
