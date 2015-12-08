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
  # resources :users
  get  'users', to: 'users#new', as: :new_user
  post 'users', to: 'admin/users#create'

  # -- devise --
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

end
