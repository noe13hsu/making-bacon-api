Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :budgets
      resources :transactions
      resources :categories
      resources :users

      get 'category/income', to: 'categories#income'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
