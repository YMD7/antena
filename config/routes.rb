Rails.application.routes.draw do

  # -- root --
  root to: 'static_pages#top'

  # -- static pages --
  get 'gate',  :to => 'static_pages#gate'

  # -- resources --
  resources :posts
  get  'users', to: 'users#new', as: :new_user
  post 'users', to: 'admin/users#create'

  # -- admin --
  get 'admin', :to => 'admin/posts#index'
  namespace :admin do
    post 'posts/confirm', to: 'posts#confirm'
    resources :posts
    resources :users
  end

  # -- devise --
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

end
