Rails.application.routes.draw do
  root "beers#index"
  resources :beers, only: [:index, :show]
end
