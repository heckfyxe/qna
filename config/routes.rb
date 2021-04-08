Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    post :vote_up, controller: :votes
    post :vote_down, controller: :votes
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, except: %i[index show new edit] do
      member do
        post 'mark_as_the_best'
      end
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => '/cable'
end
