# frozen_string_literal: true

# FavouritesController handles the creation and deletion of favourites.
class FavouritesController < ApplicationController
  before_action :set_post, only: %i[create destroy]
  before_action :set_user, only: [:index]

  # Displays a list of favourited posts for a user.
  def index
    @posts = @user.favourited_posts
  end

  # Creates a new favourite for a post.
  def create
    @favourite = current_user.favourites.build(post: @post)
    @favourite.save
    redirect_back fallback_location: root_path
  end

  # Deletes a favourite for a post.
  def destroy
    @favourite = current_user.favourites.find_by(post_id: @post.id)
    @favourite&.destroy
    redirect_back fallback_location: root_path
  end

  private

  # Sets the post for the favourite.
  def set_post
    @post = Post.find(params[:post_id])
  end

  # Sets the user for the favourite.
  def set_user
    @user = User.find(params[:user_id])
  end
end
