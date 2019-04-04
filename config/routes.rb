Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  resources :trips do
    resources :cities, only: [:show, :index, :update] do
      resources :trip_activities, only: :show
      put '/trip_activities/:id', to: 'trip_activities#update_trip', as: 'update_trip'
    end
    resources :requests, only: :create
    resources :favorite_itineraries, only: [:create, :destroy]
    resources :itineraries, only: [:index]
  end

  resources :itineraries, only: [:show, :index]

  resources :user_activities, only: [:create, :update]
  post '/user_activities', to: 'user_activities#update_profile', as: 'update_profile'
end
