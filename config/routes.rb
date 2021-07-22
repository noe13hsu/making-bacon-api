Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/register', to: 'users#create'
      post '/login', to: 'users#login'

      scope :users do
        resources :transactions, path: '/:user_id/transactions'
        resources :categories, path: '/:user_id/categories'

        get '/:user_id/income_categories', to: 'categories#income'
        get '/:user_id/expense_categories', to: 'categories#expense'

        get '/:user_id/expense_transactions', to: 'transactions#expense'
        get '/:user_id/income_transactions', to: 'transactions#income'

        get '/:user_id/budget', to: 'budgets#index'
        put '/:user_id/budget', to: 'budgets#update'
        patch '/:user_id/budget', to: 'budgets#update'

        get '/:user_id', to: 'users#show'
        put '/:user_id', to: 'users#update'
        patch '/:user_id', to: 'users#update'
        delete '/:user_id', to: 'users#delete'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end