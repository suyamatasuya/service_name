class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_posts, only: [:index]

  def index
    if params[:search].present?
      @posts = Post.where('content LIKE ?', "%#{params[:search]}%").order(created_at: :desc).page(params[:page]).per(10)
    elsif params[:sort_by_favourites].present?
      @posts = Post.left_joins(:favourites).group(:id).order('COUNT(favourites.id) DESC').page(params[:page]).per(12)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(12)
    end
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
      redirect_to posts_path, notice: t('controllers.posts.create.success')
    else
      set_posts # 追加
      flash.now[:error] = t('controllers.posts.create.failure')
      render :index
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('controllers.posts.update.success')
    else
      flash.now[:error] = t('controllers.posts.update.failure')
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t('controllers.posts.destroy.success')
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :pain_location)
  end
end
