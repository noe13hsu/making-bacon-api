Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, path: '/user/transactions'
      resources :categories, path: '/user/categories'

      # post 'categories', to: 'categories#create'
      get '/user/income_categories', to: 'categories#income'
      get '/user/expense_categories', to: 'categories#expense'

      get '/user/expense_transactions', to: 'transactions#expense'
      get '/user/income_transactions', to: 'transactions#income'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
