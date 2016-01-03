class Admin::PostsController < AdminController
  layout 'admin'

  def index
  end

  def new
    @post = Post.new
    @users = User.all
    @current_user = current_user
  end

  def create
    p = params[:post]
    post = Post.new
    post.attributes = {
      user_id:    p[:user_id],
      comment:    p[:comment],
      seed_title: p[:seed_title],
      image_src:  p[:image_src]
    }

    flash.notice = post
    redirect_to new_post_path
  end

  def confirm
    type = params[:post][:type]
    @view_data = params[:post]["#{type}_post"]
    @view_data[:type] = type
  end
end
