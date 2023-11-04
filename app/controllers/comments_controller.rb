# frozen_string_literal: true

# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params.merge(user_id: current_user.id))
    redirect_to post_path(@post)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to post_path(@comment.post), notice: 'コメントが削除されました。'
    else
      redirect_to post_path(@comment.post), alert: '権限がありません。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
