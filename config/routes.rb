require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    resources :admins
    resources :content, only: :index
    post '/auth/login', to: 'authentication#login'
  end
  telegram_webhook Telegram::WebhookController

  get '/*a', to: 'application#not_found'
end
