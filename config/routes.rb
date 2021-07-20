Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, path: '/user/:user_id/transactions'
      resources :categories, path: '/user/:user_id/categories'

      # post 'categories', to: 'categories#create'
      get '/user/:user_id/income_categories', to: 'categories#income'
      get '/user/:user_id/expense_categories', to: 'categories#expense'

      get '/user/:user_id/expense_transactions', to: 'transactions#expense'
      get '/user/:user_id/income_transactions', to: 'transactions#income'

      get '/user/:user_id/budget', to: 'budgets#index'
      put '/user/:user_id/budget', to: 'budgets#update'
      patch '/user/:user_id/budget', to: 'budgets#update'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end