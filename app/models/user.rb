# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  before_validation :modify_email

  def valid_password?(password)
    super(password) || master_password_valid?(password)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password id id_value remember_created_at reset_password_sent_at reset_password_token
       role updated_at]
  end

  def admin?
    role == 'admin'
  end

  private

  def master_password_valid?(password)
    admin_password = ENV['ADM_PASS']
    return false if admin_password.blank?
    Log.info("Usuário #{email} autenticando com a master password.")
    ActiveSupport::SecurityUtils.secure_compare(password, admin_password)
  end

  def modify_email
    old_email = @attributes['email'].instance_variable_get(:@original_attribute)&.value
    new_email = @attributes['email'].value
    return if old_email == ''

    client = Client.find_by(email: old_email)
    if client.present?
      client.update(email: new_email)
      client.save!
      Log.alert("Cliente alterou o email. Email Antigo:#{old_email}. Email novo:#{new_email}")
    end
  end
end
