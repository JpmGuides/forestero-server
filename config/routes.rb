Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  resources :reports, only: [:create, :index]

  root to: 'reports#index'
end
