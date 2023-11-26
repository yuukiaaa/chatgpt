Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tops#index"

  resources :tops, only: [:index]
  post '/tops/message', to: 'tops#message', as: 'message_tops'
  get '/tops/about', to: 'tops#about'

  resources :users, except: :index

  # resources :sessions, only: [:new, :create, :destroy]

  resources :sessions, only: [:new, :create]
  delete '/logout', to: 'sessions#destroy'
end
