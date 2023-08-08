Rails.application.routes.draw do
  resources :meetings do
    collection do
      get :business_week
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "meetings#index"
end
