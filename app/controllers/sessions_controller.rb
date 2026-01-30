class SessionsController < ApplicationController
  def new
  end

  # app/controllers/sessions_controller.rb
  def create
    user = User.find_by(username: params[:session][:username])
    
    if user && user.authenticate(params[:session][:password])
      log_in user # 普通にログインするだけ
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