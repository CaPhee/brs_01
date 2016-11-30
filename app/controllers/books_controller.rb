class BooksController < ApplicationController

  def index
    @books = Book.search(params[:key]).of_category(params[:category_id])
      .page(params[:page]).per Settings.book.per_page_book
    @categories = Category.all
    if user_signed_in?
      @reading_books = current_user.books.reading
      @read_books = current_user.books.read
    end
  end

  def show
    @book = if current_user && current_user.admin
        Book
      else
        Book.unscoped
      end.find_by id: params[:id]
    if @book
      @reviews = @book.reviews.page(params[:page])
        .per Settings.book.per_page_review
      if user_signed_in?
        @review = Review.find_or_initialize_by book_id: @book.id,
          user_id: current_user.id
        @favorite = Favorite.find_by book_id: @book.id, user_id: current_user.id
      end
    else
      flash[:danger] = t :not_fould, objectClass: Book.name
      redirect_to root_url
    end
  end
end
