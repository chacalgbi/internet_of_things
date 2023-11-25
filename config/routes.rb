# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  authenticate :user do
    resources :clients
    resources :channels
    resources :devices
  end

  get '/list', to: 'home#list'
  root to: 'home#index'
end
