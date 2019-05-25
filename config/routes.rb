require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    resources :admins
    resources :content, only: :index
    post '/auth/login', to: 'authentication#login'
  end
  get '/*a', to: 'application#not_found'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
