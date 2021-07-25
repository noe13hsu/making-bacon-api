Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/register', to: 'users#create'
      post '/login', to: 'users#login'

      get '/user/transactions', to: "transactions#index"
      post '/user/transactions', to: "transactions#create"
      get '/user/transactions/:id', to: "transactions#show"
      put '/user/transactions/:id', to: "transactions#update"
      patch '/user/transactions/:id', to: "transactions#update"
      delete '/user/transactions/:id', to: "transactions#destroy"

      get '/user/categories', to: "categories#index"
      post '/user/categories', to: "categories#create"
      get '/user/categories/:id', to: "categories#show"
      put '/user/categories/:id', to: "categories#update"
      patch '/user/categories/:id', to: "categories#update"
      delete '/user/categories/:id', to: "categories#destroy"

      # get '/user/income_categories', to: 'categories#income'
      # get '/user/expense_categories', to: 'categories#expense'

      # get '/user/expense_transactions', to: 'transactions#expense'
      # get '/user/income_transactions', to: 'transactions#income'

      get '/user/budget', to: 'budgets#index'
      put '/user/budget', to: 'budgets#update'
      patch '/user/budget', to: 'budgets#update'

      get '/user/me', to: 'users#show'
      put '/user/me', to: 'users#update'
      patch '/user/me', to: 'users#update'
      delete '/user/me', to: 'users#delete'
      post '/user/me', to: 'users#create'

    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end