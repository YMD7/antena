class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
  end

  def new
    @user = User.new
  end
end
