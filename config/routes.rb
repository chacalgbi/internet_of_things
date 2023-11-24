# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  authenticate :user do
    get '/list', to: 'home#list'
  end
  get '/', to: 'home#index'
end
