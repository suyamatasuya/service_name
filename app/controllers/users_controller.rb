# frozen_string_literal: true

# UsersController handles user-related actions.
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update]

  # Initializes a new user.
  def new
    @user = User.new
  end

  # Creates a new user.
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_session_path(@user), notice: I18n.t('controllers.users.create.success')
    else
      render :new
    end
  end

  # Displays the edit form for a user.
  def edit; end

  # Displays a user's profile.
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  private

  # Sets the user for actions that require it.
  def set_user
    @user = User.find(params[:id])
  end

  # Strong parameters for user.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
