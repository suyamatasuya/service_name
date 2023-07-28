class FavouritesController < ApplicationController
  before_action :set_post, only: [:create, :destroy]
  before_action :set_user, only: [:index]
  
  def index
    @posts = @user.favourited_posts
  end
  
  def create
    @favourite = current_user.favourites.build(post: @post)
    if @favourite.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @favourite = current_user.favourites.find_by(post_id: @post.id)
    if @favourite&.destroy
      redirect_back fallback_location: root_path, success: t('.success')
    else
      redirect_back fallback_location: root_path, danger: t('.failure')
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
