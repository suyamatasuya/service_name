class FavouritesController < ApplicationController
  before_action :set_post, only: [:create]

  def index
    @user = User.find(params[:user_id])
    @posts = @user.favourites.map(&:post)
  end
  
  def create
    favourite = current_user.favourites.build(post: @post)
  
    if favourite.save
      render json: { favourite_count: @post.favourites.count }
    else
      Rails.logger.debug favourite.errors.full_messages.join("\n")
      render json: { error: favourite.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    favourite = current_user.favourites.find_by(post_id: params[:post_id])
  
    if favourite&.destroy
      render json: { favourite_count: @post.favourites.count }
    else
      render json: { error: 'Error' }, status: :unprocessable_entity
    end
  end  

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
