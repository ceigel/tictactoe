Rails.application.routes.draw do

  resources :games, except: [:edit, :update, :destroy] do
    resources :rounds, only: [:update]
  end
  root 'games#index'
end
