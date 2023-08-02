class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :favourite, :unfavourite]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favourite, :unfavourite]

  def index
    @posts = if params[:search].present?
               Post.where('content LIKE ?', "%#{params[:search]}%")
             elsif params[:sort_by_favourites].present?
               Post.left_joins(:favourites).group(:id).order('COUNT(favourites.id) DESC')
             else
               Post.order(created_at: :desc)
             end.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end  

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: t('controllers.posts.create.success')
    else
      flash.now[:error] = t('controllers.posts.create.failure')
      render :index
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: t('controllers.posts.update.success')
    else
      flash.now[:error] = t('controllers.posts.update.failure')
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t('controllers.posts.destroy.success')
  end

  def favourite
    @post.favourites.create(user_id: current_user.id)
    render json: { favourites_count: @post.favourites.count }
  end
  
  def unfavourite
    favourite = @post.favourites.find_by(user_id: current_user.id)
    favourite.destroy if favourite
    render json: { favourites_count: @post.favourites.count }
  end
  
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :pain_location)
  end
end
