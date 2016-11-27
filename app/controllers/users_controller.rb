class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t :user_not_found
      redirect_to root_url and return
    end
    @activities = Activity.includes(:likes).users_activities(@user.id)
      .page(params[:page]).per Settings.user.activities_per_page
    @reading_books = current_user.books.reading.page(params[:page])
      .per Settings.user.activities_per_page
    @read_books = current_user.books.read.page(params[:page])
      .per Settings.user.activities_per_page
    @favorites = current_user.favorite_books.page(params[:page])
      .per Settings.user.activities_per_page
    if user_signed_in?
      @relationship = current_user.active_relationships
        .find_or_initialize_by followed_id: @user.id
    end
  end
end
