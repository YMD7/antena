class StaticPagesController < ApplicationController
  def top
    @need_menu_and_project = true
  end

  def gate
    @need_menu_and_project = true
  end
end
