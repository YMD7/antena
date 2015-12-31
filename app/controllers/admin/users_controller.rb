class Admin::UsersController < AdminController
  layout 'admin'

  def index
    @users = User.all
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

      new_user = User.invite!(
        :username       => username,
        :email          => params["mail"],
        :role           => params["role"],
        :family_name_jp => params["family_name_jp"],
        :first_name_jp  => params["first_name_jp"],
        :family_name_en => params["family_name_en"],
        :first_name_en  => params["first_name_en"],
        :affiliate      => params["affiliate"]
      )
      make_default_icon(new_user)
      flash.notice = "#{params["mail"]} に招待メールを送信しました！"
      redirect_to :action => 'new'
    end
  end

  def make_default_icon(user)
    id = user.id
    icons_dir = 'app/assets/images/user_icons/'
    FileUtils.cp("#{icons_dir}no_icon.jpg", "#{icons_dir}#{id}.jpg")
  end
end
