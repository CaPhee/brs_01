class LikesController < ApplicationController
  authorize_resource
  before_action :load_like, only: :destroy

  def create
    @messages = Hash.new
    @like = Like.find_or_initialize_by activity_id: params[:activity_id],
      user_id: current_user.id
    if @like.save
      @messages[:success] = t :like
    else
      @messages[:danger] = @like.errors.full_messages.join "</br>"
    end
  end

  def destroy
    @messages = Hash.new
    if @like.destroy
      @messages[:success] = t :unlike
    else
      @messages[:danger] = @like.errors.full_messages.join "</br>"
    end
  end

  private
  def load_like
    @like = Like.find_by id: params[:id]
  end
end
