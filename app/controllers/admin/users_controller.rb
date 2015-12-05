class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
  end

  def new
    @user   = User.new
    @mailer = YAML.load(File.open("config/locales/devise_invitable.ja.yml"))["ja"]["devise"]["mailer"]["invitation_instructions"]
    @mailer["someone_invited_you"].gsub!(/%\{url\}/, "\##{root_url}\#")
  end
end
