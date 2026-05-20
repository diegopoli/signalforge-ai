Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end

  root "home#index"
  get "/dashboard", to: "dashboard#index"

  resources :clients do
    resources :notes, only: [:create]
    resources :documents, only: [:create]
  end

  resources :documents, only: [:index, :new, :create]
  resource :ai_assistant, only: [:show], controller: :ai_assistant do
    post :search
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
