Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  namespace :v1 do
    # 基本的なメソッドを一括で表したい場合
    resources :users

    # 特定のメソッドを使用しない場合
    # resources :users, only: [:index, :show, :create]

    # 個別にメソッドを定義したい場合
    # get '/users', to: 'users#index'
    # post '/users', to: 'users#create'
    # get '/users/:id', to: 'users#show'
    # patch '/users/:id', to: 'users#update'
    # delete '/users/:id', to: 'users#destroy'
  end
end
