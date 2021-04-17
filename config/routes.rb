require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    post :vote_up, controller: :votes
    post :vote_down, controller: :votes
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create

    resources :answers, concerns: :votable, shallow: true, except: %i[index show new edit] do
      member do
        post 'mark_as_the_best'
      end

      resources :comments, only: :create
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => '/cable'
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
    end
  end
end
