Rails.application.routes.draw do

  root to: 'static_pages#top'
  get 'gate', :to => 'static_pages#gate'

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

  namespace :admin do
    resources :posts
    resources :users
  end

  resources :posts

end
