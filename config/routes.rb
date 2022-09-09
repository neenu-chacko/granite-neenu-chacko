# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  constraints(lambda { |req| req.format == :json }) do
    # resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: %i[index create]
    resource :session, only: [:create, :destroy]
    resources :comments, only: :create
    resource :preference, only: %i[show update] do
      patch :mail, on: :collection
    end
    resources :tasks, except: %i[new edit], param: :slug do
      collection do
        resource :report, only: %i[create], module: :tasks do
          get :download, on: :collection
        end
      end
    end

  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
