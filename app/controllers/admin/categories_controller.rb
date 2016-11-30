class Admin::CategoriesController < ApplicationController
  layout "layouts/admin_layout"
  before_action :load_category, only: [:edit, :update, :destroy]
  authorize_resource :category

  def index
    @categories = Category.search(params[:key]).page params[:page]
    @category = Category.new
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:info] = t :created, objectClass: :category, name: @category.name
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t :updated, objectClass: :category, name: @category.name
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    unless @category.delete
      flash[:warning] = t :failed, name: @category.name
      redirect_to admin_categories_path
    end
  end

  private
  def category_params
    params.require(:category).permit :name
  end

  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t :not_fould, objectClass: Category.name
      redirect_to admin_categories_path
    end
  end
end
