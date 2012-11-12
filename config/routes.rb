LangTrainer::Application.routes.draw do
  root to: "application#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin'                  => 'sessions#new',     as: :signin
  match '/signout'                 => 'sessions#destroy', as: :signout
  match '/auth/failure'            => 'sessions#failure'

  resources :dictionaries
end
