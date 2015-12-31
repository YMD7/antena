class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, :user

  def user
    @admin_user = current_user

    @id            = @admin_user.id
    @role          = '権限未設定'
    @role          = '管理者' if @admin_user.role == 'admin'
    @role          = '投稿者' if @admin_user.role == 'author'
    @username      = @admin_user.username
    @fullname_jp   = "#{@admin_user.family_name_jp} #{@admin_user.first_name_jp}" unless @admin_user.family_name_jp + @admin_user.first_name_jp == ''
    @affiliate     = @admin_user.affiliate
  end

  def home
  end
end
