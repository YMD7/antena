class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
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
end
