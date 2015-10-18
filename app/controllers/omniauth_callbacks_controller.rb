class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # profiderとuidでuserレコードを検索
    user = User.from_omniauth(request.env["omniauth.auth"])

    # userレコードが既に保存されているか
    if user.persisted?
      # ログインに成功
      flash.notice = "ログインしました"
      sign_in_and_redirect user
    else
      # ログインに失敗し、サインイン画面に遷移
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
end
