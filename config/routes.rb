Rails.application.routes.draw do

  root to: 'pages#index'

  match 'gate', :to => 'pages#login_gate', :via => 'get'
  match 'admin', :to => 'admin#home', :via => 'get'

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    invitations: "users/invitations"
  }

end
