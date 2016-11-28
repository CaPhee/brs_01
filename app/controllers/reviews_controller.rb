class ReviewsController < ApplicationController
  authorize_resource :review
  before_action :load_review, except: [:new, :create, :index]

  def create
    @review = current_user.reviews.build review_params
    if @review.save
      flash[:success] = t :created, objectClass: :review, name: @review.title
      redirect_to @review.book
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @review.update_attributes review_params
      flash[:success] = t :updated, objectClass: :review, name: @review.title
        redirect_to @review.book
      else
       render :edit
      end
  end

  def show
    @book = @review.book
    @comments = @review.comments.page(params[:page]).per Settings.per_page_comments
    if user_signed_in?
      @reading_books = current_user.books.reading
      @read_books = current_user.books.read
      @comment = Comment.new
    end
  end

  private
  def review_params
    params.require(:review).permit :book_id, :rate, :title, :content
  end

  def load_review
    @review = Review.find_by id: params[:id]
    unless @review
      flash[:danger] = t :not_fould, object: Review.name
      redirect_to books_path
    end
  end
end
