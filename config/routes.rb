Rails.application.routes.draw do
  namespace :admin do
    get 'genres/index'
    get 'genres/edit'
  end
  namespace :admin do
    get 'orders/index'
    get 'orders/show'
    get 'orders/update'
  end
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

    delete '/cart_items' => 'cart_items#destroy_all', as: "cart_items"
    resources :cart_items, only: [:index, :update, :destroy, :create]
    
    post 'orders/address' => "orders#create_address"
    get 'orders/confirm' => 'orders#confirm'
    get 'orders/done' => 'orders#done'
    post 'orders/register' => 'orders#register'
    get 'orders/pay/:pre_payment' => 'orders#pay', as: "pay"
    resources :orders, only: [:new, :create, :index, :show]
  end
  namespace :admin do
    get '/top' => 'tops#top'
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :edit, :update, :create]

    patch 'orders/delivery/:id' => 'orders#update_delivery', as: 'delivery'
    resources :orders, only: [:index, :show, :update]
    resources :end_users, except: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
