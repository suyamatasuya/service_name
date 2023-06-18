class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:index]

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def index
  end

  def set_posts
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: '投稿が作成されました'
    else
      set_posts # 追加
      flash.now[:error] = '投稿の作成に失敗しました'
      render :index
    end
  end
  

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました'
    else
      flash.now[:error] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :body_part)
  end
end
