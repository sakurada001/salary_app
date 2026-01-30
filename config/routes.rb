Rails.application.routes.draw do
  root   "sessions#new"

  # ログイン・ログアウト
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get    "/logout",  to: "sessions#destroy"

  # ✅ 打刻用ルート（JavaScript用）
  post '/clock_in',  to: 'attendances#clock_in'
  post '/clock_out', to: 'attendances#clock_out'

  # ✅ メイン画面（エラーの原因はここです！ as: :attendance_form を忘れずに）
  get    "/home",       to: "static_pages#home"
  get    "/attendance", to: "static_pages#attendance", as: :attendance_form

  # ユーザー・勤怠履歴
  resources :users
  resources :attendances
  
  get    "/signup",  to: "users#new"
  post   "/signup",  to: "users#create"
end