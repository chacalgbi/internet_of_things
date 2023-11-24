# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    redirect_to root_path, alert: 'Acesso não autorizado' unless current_user.admin?
  end
end
