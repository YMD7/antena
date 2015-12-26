class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require "open-uri"
  require "FileUtils"

  def facebook
    # binding.pry_remote
    # invitation_token をURLから取得
    invitation_token = get_token(request.env["omniauth.origin"])

    # invitation_token があり、かつユーザーが存在していない場合、ユーザーを作成する
    if invitation_token && User.from_omniauth(request.env["omniauth.auth"]).nil?
      auth = request.env["omniauth.auth"]
      User.accept_invitation!(
        :invitation_token => invitation_token,
        :provider         => auth.provider,
        :uid              => auth.uid,
        :username         => auth.info.name,
        :first_name_en    => auth.info.first_name,
        :family_name_en   => auth.info.last_name
        # info.image でアイコン画像のURL
      )
      save_profile_icon(auth)
    end

    # providerとuidでuserレコードを検索
    user = User.from_omniauth(request.env["omniauth.auth"])

    # 対象ユーザーがuserレコードにあったか
    if user
      # ログインに成功
      sign_in user, :event => :authentication
      flash.notice = I18n.t "devise.sessions.signed_in"
      redirect_to gate_url
    else
      # ログインに失敗し、サインイン画面に遷移
      flash.notice = "ログインに失敗しました"
      redirect_to gate_url
    end
  end

  def get_token(url)
    url.split('invitation_token=')[1]
  end

  def save_profile_icon(auth)
    username = auth.info.name.gsub(' ', '_')
    icon_uri = auth.info.image
    icon_ext = File.extname(icon_uri)
    file_dir = "/app/assets/images/user_icons/"
    file_path = file_dir + username + icon_ext

    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)

    open(file_path, 'wb') do |icon_file|
      open(icon_uri) do |icon_data|
        icon_file.write(icon_data.read)
      end
    end
  end
end
