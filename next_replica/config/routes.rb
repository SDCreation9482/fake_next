Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :quests do
    collection do
      post :import
    end
  end

  namespace :api do
    namespace :v1 do
      resources :quests, only: %i[index show]
    end
  end

  mount ActionCable.server => "/cable"
end
