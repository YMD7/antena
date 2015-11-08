Rails.application.routes.draw do

  # -- root --
  root to: 'static_pages#top'

  # -- static pages --
  get 'gate',  :to => 'static_pages#gate'

  # -- admin --
  get 'admin', :to => 'admin/posts#index'
  namespace :admin do
    resources :posts
    resources :users
  end

  # -- resources --
  resources :posts

  # -- devise --
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

end
