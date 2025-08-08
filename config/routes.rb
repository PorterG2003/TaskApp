Rails.application.routes.draw do
  get "home/index"
  # Authentication routes
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  delete '/logout', to: 'sessions#destroy'

  resources :tasks, except: [:new]
  get "offline", to: "pages#offline"
  get "migrate", to: "pages#migrate"

  # Calendar
  get "calendar", to: "calendar#index"
  post "calendar/generate_task", to: "calendar#generate_task"
  
  # Component preview (development only)
  if Rails.env.development?
    get "components", to: "components#index"
    get "components/:component", to: "components#show"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "manifest" => "pwa#manifest", as: :pwa_manifest
  get "service-worker" => "pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
