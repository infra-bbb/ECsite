Rails.application.routes.draw do
  # namespace :public do
  #   get 'items/index'
  #   get 'items/root'
  #   get 'items/show'
  # end
  # namespace :admin do
  #   get 'end_users/index'
  #   get 'end_users/show'
  #   get 'end_users/edit'
  #   get 'end_users/update'
  #   get 'end_users/destroy'
  # end
  # namespace :public do
  #   get 'end_users/show'
  #   get 'end_users/edit'
  #   get 'end_users/update'
  #   get 'end_users/status'
  # end
  # namespace :admin do
  #   get 'items/new'
  #   get 'items/create'
  #   get 'items/index'
  #   get 'items/show'
  #   get 'items/edit'
  #   get 'items/update'
  # end
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :end_users, controllers: {
    sessions:      'end_users/sessions',
    passwords:     'end_users/passwords',
    registrations: 'end_users/registrations'
  }


  root to: 'public/items#index'  
  namespace :public do
    resources :items, only: [:index, :show]
    resources :addresses, only: [:index, :create, :update, :destroy, :edit]

    resources :end_users, only: [:show, :edit, :update, :destroy]
    get 'end_users/status' => 'end_users#status'

    resources :cart_items, only: [:index, :update, :destroy, :create]
    delete 'end_users/cart_items' => 'cart_items#destroy_all'
    
    resources :orders, only: [:new, :create, :index, :show]
    get 'end_users/orders/confirm' => 'orders#confirm'
  end
  namespace :admin do
    get '/top' => 'tops#top'
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :edit, :update, :create]
    resources :orders, only: [:index, :show, :update]
    resources :end_users, except: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
