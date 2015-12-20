class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    binding.pry_remote
    # invitation_token をURLから取得
    invitation_token = get_token(request.env["omniauth.origin"])

    # メンバー登録ページから来ていたら、ユーザーを作成（招待の承認）
    if invitation_token
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
    end

    # providerとuidでuserレコードを検索
    user = User.from_omniauth(request.env["omniauth.auth"])

    # 対象ユーザーがuserレコードにあったか
    if user
      # ログインに成功
      flash.notice = "ログインしました"
      sign_in user, :event => :authentication
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
end
