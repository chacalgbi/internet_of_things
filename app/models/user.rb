# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password id id_value remember_created_at reset_password_sent_at reset_password_token
       role updated_at]
  end

  def admin?
    role == 'admin'
  end
end
