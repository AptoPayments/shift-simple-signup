Rails.application.routes.draw do
  root 'users#index'
  get 'oauth_return' => 'users#oauth_return', as: :oauth_return
  resources :users
end
