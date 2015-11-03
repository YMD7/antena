class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!

  def home
  end
end
