class CommentsController < ApplicationController
  before_action :load_comment, only: [:edit, :update, :destroy]
  before_action :load_commentator, only: :create
  authorize_resource :comment

  def create
    @comment = @commentator.comments.build comment_params
    if @comment.save
      flash[:info] = t :add_comment, name: @comment.title
    else
      flash[:danger] = @comment.error.full_messages.join "</br>"
    end
    redirect_to @comment.review
  end

  def edit
  end

  def update
    if @comment.update_attributes comment_params
      flash[:success] = t :updated, objectClass: :comment, name: @comment.title
    else
      flash[:danger] = @comment.error.full_messages.join "."
    end
    redirect_to @comment.review
  end

  def destroy
    unless @comment.destroy
      flash[:warning] = t :failed, name: @category.name
      redirect_to @comment.review
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end
  def load_comment
    @comment = Comment.find_by id: params[:id]
    unless @comment
      flash[:danger] = t :not_fould, objectClass: Comment.name
      redirect_to root_url
    end
  end

  def load_commentator
    @commentator = Commentator.find_or_initialize_by user_id: current_user.id,
      review_id: params[:review_id]
    unless @commentator.id
      unless @commentator.save
        flash[:danger] = t :comment_failed
        redirect_to root_url
      end
    end
  end
end
