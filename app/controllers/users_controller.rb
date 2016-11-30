class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t :user_not_found
      redirect_to root_url and return
    end
    @activities = Activity.users_activities(@user.id).page(params[:page_activities])
      .per Settings.user.activities_per_page
    @reading_books = @user.books.reading.page(params[:page_reading_books])
      .per Settings.user.activities_per_page
    @read_books = @user.books.read.page(params[:page_read_books])
      .per Settings.user.activities_per_page
    @favorites = @user.favorite_books.page(params[:page_favorites])
      .per Settings.user.activities_per_page
    @requests = @user.requests.page(params[:page_requests])
      .per Settings.user.activities_per_page
    if user_signed_in?
      @relationship = current_user.active_relationships
        .find_or_initialize_by followed_id: @user.id
    end
  end
end
