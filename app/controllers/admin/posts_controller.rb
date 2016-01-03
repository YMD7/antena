class Admin::PostsController < AdminController
  layout 'admin'

  def index
  end

  def new
    @post         = Post.new
    @users        = User.all
    @current_user = current_user
  end

  def create
    p    = params[:post]
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
    post_type  = params[:post][:post_type]
    @view_data = params[:post]["#{post_type}_post"]
    @view_data[:post_type] = post_type

    if post_type == 'single'
      res = open(@view_data[:ref_url])
      doc = Nokogiri::HTML.parse(res.read, nil, res.charset)
      @view_data[:ref_title] = doc.title
    end

    image_src_url = @view_data[:image_src_url]
    @view_data[:image_src_domain] = Mide::Str.to_domain(image_src_url)
    # file_dir      = "app/assets/images/posts/#{Time.now.strftime('%Y/%m/%d')}/"
    file_dir      = "app/assets/images/posts/confirm/"
    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)
    file_extname  = "#{File.extname(image_src_url)}"
    file_name     = "#{Post.last.id + 1}_#{Time.now.strftime('%H_%M_%S_%L')}#{file_extname}"
    image_path    = "#{file_dir}#{file_name}"
    open(image_path, 'wb') do |new_file|
      open(image_src_url) do |remote_image_data|
        new_file.write(remote_image_data.read)
      end
    end
    @tmp_image_path = file_name
  end
end
