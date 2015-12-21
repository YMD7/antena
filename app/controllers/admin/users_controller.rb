class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
  end

  def new
    @user   = User.new
    @mailer = YAML.load(File.open("config/locales/devise_invitable.ja.yml"))["ja"]["devise"]["mailer"]["invitation_instructions"]
    @mailer["someone_invited_you"].gsub!(/%\{url\}/, "\##{root_url}\#")
  end

  def create
    if User.exists?(:email => params["mail"])
      flash.alert = "既に #{params["mail"]} は招待済みです"
      redirect_to :action => 'new'
    else
      username = params["family_name_en"] == '' ?
        params["first_name_en"] : params["family_name_en"]+' '+params["first_name_en"]

      User.invite!(
        :username       => username,
        :email          => params["mail"],
        :role           => params["role"],
        :family_name_jp => params["family_name_jp"],
        :first_name_jp  => params["first_name_jp"],
        :family_name_en => params["family_name_en"],
        :first_name_en  => params["first_name_en"],
        :affiliate      => params["affiliate"]
      )
      flash.notice = "#{params["mail"]} に招待メールを送信しました！"
      redirect_to :action => 'new'
    end
  end
end
