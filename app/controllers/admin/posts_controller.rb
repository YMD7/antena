class Admin::PostsController < AdminController
  layout 'admin'

  def index
  end

  def new
    @post = Post.new
    @current_user_id = current_user.nil? ? nil : current_user.id
    @users = User.all
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
end
