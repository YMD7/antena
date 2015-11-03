class PagesController < ApplicationController
  def login_gate
    @hoge = user_signed_in?
  end
end
