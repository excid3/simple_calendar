Rails.application.routes.draw do
  resources :meetings do
    collection do
      get :business_week
    end
  end
  get "rooms/:room_id/meetings", to: "meetings#room", as: :room_meetings
  get "servers/:host/meetings", to: "meetings#index", as: :server_meetings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "meetings#index"
end
