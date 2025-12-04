class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
    def new
    @user = User.new
  end
  def index
    # データベースから全ユーザーを取り出す
    @users = User.all
  end
  def create
    @user = User.new(user_params)
    if @user.save
      # 成功したらホームへ
      flash[:success] = "登録が完了しました！"
      redirect_to home_path
    else
      # === ここが重要！ ===
      # 失敗したら、エラー情報を持ったまま登録画面に戻す
      # status: :unprocessable_entity がないと、画面が更新されません
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :hourly_wage)
  end
end