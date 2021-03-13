Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :users, only: :show
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :games, only: [:show, :index] do
    collection do
      get 'search'
      get 'random'
    end
  end

  resources :user_games, only: [:index] do
    collection do
      post 'setstatus'
      get 'recommendations'
    end
  end

  resources :advanced_search, only: :index

end


