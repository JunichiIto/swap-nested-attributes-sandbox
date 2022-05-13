Rails.application.routes.draw do
  resources :books, only: %i(show update)
end
