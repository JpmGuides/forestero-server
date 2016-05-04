Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :reports, only: [:create, :index] do
    collection do
      get 'raw'
    end
  end

  root to: 'reports#index'
end
