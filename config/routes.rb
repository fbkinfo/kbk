Kbk::Application.routes.draw do
  devise_for :users

  root to: 'investigations#index'

  resources :documents do
    resource :star, only: [:create, :destroy], controller: 'favourites'

    resources :snapshots, only: :create
    resources :attachements, controller: 'document_attachements', only: [:create, :destroy]
  end

  resources :videos, :links, only: [:create, :destroy]

  resources :photos, only: [:create, :destroy] do
    collection do
      post :finalize
    end
  end

  resources :attachements, controller: 'document_attachements', only: [:create, :destroy]

  resources :investigations do
    resource :star, only: [:create, :destroy], controller: 'favourites'
    member do
      put :publish
      put :unpublish
    end
  end

  resources :snapshots, only: [:create, :destroy, :update] do
    collection do
      post :sort
    end
  end

  resources :organizations, except: :show

  resources :users, except: :show do
    member do
      get :unlock
    end
  end

end
