class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
  end

  def new
    @user   = User.new
    @mailer = YAML.load(File.open("config/locales/devise_invitable.en.yml"))["en"]["devise"]["mailer"]
  end
end
