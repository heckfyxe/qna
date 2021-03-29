Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, except: %i[index show new edit] do
      member do
        post 'mark_as_the_best'
      end
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
end
