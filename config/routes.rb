Rails.application.routes.draw do
  root "landing#index"
  resource :session, path: "", path_names: { new: 'sign_in'}
  resources :passwords, param: :token

  resources :users, only: [:create]
  get "mypage", to: "users#mypage"
  get "mypage/edit", to: "users#edit", as: :edit_mypage
  patch "mypage", to: "users#update"
  delete "mypage", to: "users#destroy"
  get "sign_up", to: "users#new", as: :new_user

  resources :posts do
    resources :comments, only: %i[create destroy]
    resources :visits, only: %i[new create]
    resources :bookmarks, only: %i[create destroy]
  end
  get "home", to: "homes#top", as: :home
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :users, only: %i[index show edit update]
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
end
