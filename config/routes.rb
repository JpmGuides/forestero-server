Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :day_texts, only: [:create]
  resources :reports, only: [:create, :index] do
    collection do
      get 'raw'
      get 'demo'
    end
  end

  root to: 'reports#index'
end
