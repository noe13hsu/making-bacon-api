Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, path: '/user/transactions'
      resources :categories, path: '/user/categories'

      # post 'categories', to: 'categories#create'
      get '/user/income', to: 'categories#income'
      get '/user/expense', to: 'categories#expense'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
