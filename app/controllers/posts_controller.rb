# frozen_string_literal: true

# PostsController handles CRUD operations for Posts.
class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update favourite unfavourite]
  before_action :set_post, only: %i[show edit update destroy favourite unfavourite]

  # Displays a list of posts based on search and sorting parameters.
  def index
    @posts = fetch_posts.page(params[:page]).per(10)
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    process_create
  end

  def edit; end

  def update
    process_update
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
    favourite&.destroy
    render json: { favourites_count: @post.favourites.count }
  end

  private

  def set_post
    @post = Post.includes(comments: :user).find(params[:id])
    # Initialize a new comment for the form in the show action
    @comment = @post.comments.build
  end

  def fetch_posts
    if params[:search].present?
      Post.where('content LIKE ?', "%#{params[:search]}%")
    elsif params[:sort_by_favourites].present?
      Post.left_joins(:favourites).group(:id).order('COUNT(favourites.id) DESC')
    else
      Post.order(created_at: :desc)
    end
  end

  def process_create
    if @post.save
      redirect_to posts_path, notice: t('controllers.posts.create.success')
    else
      flash.now[:error] = t('controllers.posts.create.failure')
      render :index
    end
  end

  def process_update
    if @post.update(post_params)
      redirect_to posts_path, notice: t('controllers.posts.update.success')
    else
      flash.now[:error] = t('controllers.posts.update.failure')
      render :edit
    end
  end

  def post_params
    params.require(:post).permit(:content, :pain_location)
  end
end
