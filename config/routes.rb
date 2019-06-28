require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    resources :admins
    resources :content, only: :index
    post '/auth/login', to: 'authentication#login'
  end
  telegram_webhook Telegram::WebhookController
  mount RailsDb::Engine => '/rails/db', :as => 'api_rails_db'
  get '/*a', to: 'application#not_found'
end
