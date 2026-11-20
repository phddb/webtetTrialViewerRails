Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resource :synchronization, only: :create
  resource :export, only: :show

  root "home#index"
end
