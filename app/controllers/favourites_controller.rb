class FavouritesController < ApplicationController
  before_action :set_post, only: [:create]

  def index
    @user = User.find(params[:user_id])
    @posts = @user.favourites.map(&:post)
  end
  
  def create
    if current_user.favourites.exists?(post: @post)
      render json: { error: 'You have already favourited this post' }, status: :unprocessable_entity
    else
      favourite = current_user.favourites.build(post: @post)
  
      if favourite.save
        render json: { status: 'created', favourite_id: favourite.id }
      else
        render json: { error: favourite.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    favourite = Favourite.find(params[:id]) # 修正: IDを使ってお気に入りを探す
  
    if favourite.nil?
      render json: { error: 'Favourite not found' }, status: :unprocessable_entity
    else
      if favourite.destroy
        render json: { status: 'deleted' } # 修正: 成功したらステータスを返す
      else
        render json: { error: 'Failed to destroy favourite' }, status: :unprocessable_entity
      end
    end
  end  

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
