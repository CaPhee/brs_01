Rails.application.routes.draw do
  root "static_pages#home"
  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :books, only: [:index, :show]
  namespace :admin do
    resources :books, except: :show
    resources :categories, except: :show
    resources :users, only: [:index, :destroy]
    resources :requests, except: [:new, :create]
  end
  require "sidekiq/web"
  mount Sidekiq::Web, at: "/sidekiq"
  resources :marks
  resources :favorites, only: [:index, :create, :destroy]
  resources :reviews, except: [:new, :index]
  resources :users, only: :show do
    resources :following, only: :index
    resources :followers, only: :index
  end
  resources :relationships, only: [:create, :destroy]
  resources :requests, except: [:index]
  resources :comments, except: [:new, :show, :index]
end
