class SessionsController < ApplicationController
  def new
  end

  def create
   # user_id カラムに対して、フォームから送られた username を使って検索する
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      reset_session # セッション固定攻撃対策 [cite: 111]
      # 第12回のポイント：チェックボックスの値で分岐 [cite: 131, 136]
     # 三項演算子で書くのが講義資料のスタイルです
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to home_path
    else
      flash.now[:danger] = 'ユーザーIDまたはパスワードが正しくありません'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end