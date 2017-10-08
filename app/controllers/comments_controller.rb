class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose(:comment)

  def create
    if comment.save
      redirect_to movie_path(params[:movie_id]), notice: "Comment added"
    else
      redirect_to movie_path(params[:movie_id]), alert: "Unable to add comment"
    end
  end

  def destroy
    if current_user.id == comment.user_id
      comment.destroy
      redirect_to movie_path(params[:movie_id]), notice: "Comment deleted"
    else
      redirect_to movie_path(params[:movie_id]), alert: "Unable to delete comment"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id, movie_id: params[:movie_id])
  end
end
