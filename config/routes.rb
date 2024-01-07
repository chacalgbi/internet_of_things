# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  authenticate :user do
    resources :clients
    resources :channels
    resources :devices
    root to: 'home#index'
    post '/others', to: 'home#others'
    get '/register_device', to: 'register_device#index'
    get '/info', to: 'home#info'
  end

  post '/device_login', to: 'iot#device_login'
  post '/mqtt_info', to: 'iot#mqtt_info'
  post '/alertaTelegram', to: 'iot#telegram'
  post '/alertaWhatsApp', to: 'iot#whatsapp'
  post '/alertaEmail', to: 'iot#email'
end
