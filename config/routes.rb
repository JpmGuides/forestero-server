Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :users, only: [:index, :show, :new, :create, :edit, :update]

  root to: 'users#index'
end
