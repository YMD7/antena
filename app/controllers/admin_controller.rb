class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, :user

  def user
    @user = current_user

    @role          = '権限未設定'
    @role          = '管理者' if @user.role == 'admin'
    @role          = '投稿者' if @user.role == 'author'
    @username      = @user.username
    @fullname_jp   = "#{@user.family_name_jp} #{@user.first_name_jp}" if @user.family_name_jp && @user.first_name_jp
    @affiliate     = @user.affiliate
    @icon_filename = @username.gsub(' ', '_')
    file_dir  = "app/assets/images/user_icons/"
    file_path = file_dir + @icon_filename + ".jpg"
    unless FileTest.exist?(file_path) then @icon_filename = 'no_icon' end
  end

  def home
  end
end
