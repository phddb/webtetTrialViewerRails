require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  resource :synchronization, only: :create
  resource :export, only: :show

  root "home#index"
end
