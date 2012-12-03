LangTrainer::Application.routes.draw do
  root to: "dictionaries#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin'                  => 'sessions#new',     as: :signin
  match '/signout'                 => 'sessions#destroy', as: :signout
  match '/auth/failure'            => 'sessions#failure'

  resources :identities

  resources :dictionaries do
    resources :books
    resources :entries
  end

  resources :books do
    resources :chapters, except: [:index, :show] do
      resources :entries do
        put :ignore, on: :member
        put :complete, on: :member
      end
    end
  end
end
