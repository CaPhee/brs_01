class Admin::RequestsController < ApplicationController
  layout "layouts/admin_layout"
  authorize_resource
  before_action :load_request, only: [:update, :destroy]

  def index
    @categories = Category.all
    @requests = Request.includes(:user)
      .of_user(params[:user_name]).search_titile(params[:book_title])
      .of_category(params[:category_id]).page params[:page]
  end

  def update
    @messages = Hash.new
    if params[:processed].present?
      approve_request
    end
    if params[:bought].present?
      bought
    end
  end

  def destroy
    if @request.delete
      flash[:warning] = t :delete_success, name: :request
    else
      flash[:danger] = t :delete_failed, name: :request
    end
    redirect_to admin_requests_path
  end

  private
  def load_request
    @request = Request.find_by id: params[:id]
    unless @request
      flash[:danger] = t :not_fould, objectClass: Request.name
      redirect_to admin_requests_path and return
    end
  end

  def approve_request
    @request.processed = params[:processed]
    if @request.save
      @messages[:warning] = is(params[:processed]) ? t(:approve) : t(:unapprove)
    else
      @messages[:danger] = t :faild
    end
  end

  def bought
    @book = @request.book
    @book.bought = params[:bought]
    if @book.save
      @messages[:info] = is(params[:bought]) ? t(:bought) : t(:not_bought)
    else
      @messages[:danger] = t :faild
    end
  end

  def is str
    str == Settings.true
  end
end
