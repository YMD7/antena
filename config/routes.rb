Rails.application.routes.draw do

  root to: 'pages#index'

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

  match 'gate', :to => 'pages#login_gate', :via => 'get'
  match 'admin', :to => 'admin#home', :via => 'get'

  resources :posts, :path => 'admin/post'

end
