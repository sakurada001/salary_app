class UsersController < ApplicationController
  # 管理者ページを表示するアクション
  def index
    @users = User.all
  end

  # 新規登録画面を表示するアクション（ここで @user を作ります）
  def new
    @user = User.new
  end

  # 実際に登録を実行するアクション
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 登録と同時にログイン [cite: 41, 42]
      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to home_path
    else
      # 保存に失敗した場合は、エラーを表示して登録画面を再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

    def user_params
      # 仕様書 4.1 に基づき、必要な項目をすべて許可します [cite: 16-20]
      params.require(:user).permit(:name, :username, :email, :password, 
                                   :password_confirmation, :hourly_wage, :transportation_fee)
    end
end