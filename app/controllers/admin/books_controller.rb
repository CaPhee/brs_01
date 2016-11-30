class Admin::BooksController < ApplicationController
  layout "layouts/admin_layout"
  before_action :load_book, only: [:edit, :update, :destroy]
  before_action :load_category, except: [:update, :destroy]
  before_action :new_book, only: [:index, :new]
  authorize_resource :book

  def index
    @books = Book.search(params[:key]).of_category(params[:category_id]).order(:title)
      .includes(:category).page params[:page]
  end

  def new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:info] = t :created, objectClass: :book, name: @book.title
      redirect_to admin_books_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update_attributes book_params
      flash[:success] = t :updated, objectClass: :book, name: @book.title
      redirect_to admin_books_path
    else
      render :edit
    end
  end

  def destroy
    unless @book.delete
      flash[:warning] = t :failed, name: @book.title
      redirect_to admin_books_path
    end
  end

  private
  def book_params
    params.require(:book).permit :title, :publish_date, :introduce, :author,
      :number_of_pages, :cover
  end

  def load_book
    @book = Book.find_by id: params[:id]
    unless @book
      flash[:danger] = t :not_fould, objectClass: Book.name
      redirect_to admin_books_path
    end
  end

  def load_category
    @categories = Category.all
  end

  def new_book
    @book = Book.new
  end
end
