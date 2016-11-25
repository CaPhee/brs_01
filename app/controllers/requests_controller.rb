class RequestsController < ApplicationController
  authorize_resource :request
  before_action :load_request, except: [:index, :new, :create]
  before_action :processed?, only: [:edit, :update]
  before_action :load_category, except: [:update, :destroy]

  def new
    @book = Book.new
    @book.request = Request.new
  end

  def create
    @book = Book.new book_params
    @book.bought = false
    @book.request.user_id = current_user.id
    if @book.save
      flash[:info] = t :created, objectClass: :request, name: @book.title
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if@request.book.update_attributes book_params
      flash[:success] = t :updated, objectClass: :request, name: @book.title
      redirect_to @request
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    if @book.bought
      if @request.destroy
        flash[:warning] = t :delete_success, name: :request
        redirect_to admin_books_path
      else
        flash[:danger] = t :delete_failed, name: :request
        redirect_to admin_books_path
      end
    end
  end

  private
  def book_params
    params.require(:book).permit :title, :publish_date, :introduce, :author,
      :number_of_pages, :cover, :category_id,
      request_attributes: [:id, :description]
  end

  def load_request
    @request = Request.find_by id: params[:id]
    unless @request
      flash[:danger] = t :not_fould, objectClass: Request.name
      redirect_to root_path and return
    end
    @book = @request.book
    unless @book
      flash[:danger] = t :lost_request_book
      redirect_to root_path and return
    end
  end

  def processed?
    if @request.book.bought || @request.processed
      flash[:warning] = t :request_has_processed
      redirect_to root_path and return
    end
  end

  def load_category
    @categories = Category.all
  end
end
