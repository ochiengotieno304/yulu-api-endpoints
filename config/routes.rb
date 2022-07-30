Rails.application.routes.draw do
  resources :users, param: :username
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  put "/check_in", to: "users#check_in"
  put "/check_out", to: "users#check_out"
end
