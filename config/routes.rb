Rails.application.routes.draw do
  # ルートをログイン画面に設定
  root   "sessions#new"

  # ログイン・ログアウト
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get    "/logout",  to: "sessions#destroy"

  # メイン機能（出勤・退勤の住所をJavaScriptの要望に合わせる）
  post '/clock_in',  to: 'attendances#clock_in'
  post '/clock_out', to: 'attendances#clock_out'

  # ページ遷移
  get    "/home",    to: "static_pages#home"
  get    "/attendance", to: "static_pages#attendance", as: :attendance_form

  # ユーザー管理・勤怠履歴
  resources :users
  resources :attendances
  
  get    "/signup",  to: "users#new"
  post   "/signup",  to: "users#create"
end