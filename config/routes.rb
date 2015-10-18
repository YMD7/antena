Rails.application.routes.draw do

  root to: 'pages#index'
  match 'gate', :to => 'pages#login_gate', :via => 'get'
  devise_for :users,
    controllers: { omniauth_callbacks: "omniauth_callbacks" }
end
