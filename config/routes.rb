Rails.application.routes.draw do
  root "sessions#new"

  # ログイン系
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get    "/logout",  to: "sessions#destroy"

  # ✅ JavaScriptが直接アクセスするURLを「外側」に定義
  post '/clock_in',  to: 'attendances#clock_in'
  post '/clock_out', to: 'attendances#clock_out'

  # メイン機能
  get "/home", to: "static_pages#home"
  resources :users
  resources :attendances
end