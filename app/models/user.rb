class User < ApplicationRecord
  # アソシエーション
  has_many :attendances, dependent: :destroy
  
  # パスワードのハッシュ化（password_digestカラムが必要）
  has_secure_password
  
  # 仮想的な属性（データベースには保存されないが、一時的に保持する）
  #attr_accessor :remember_token

  # ---------------------------------------------------------
  # インスタンスメソッド（個別のユーザーに対して使う）
  # ---------------------------------------------------------

  # 永続セッションのためにユーザーをデータベースに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェスト（ハッシュ値）と一致するか確認する
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する（ログアウト時用）
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ---------------------------------------------------------
  # クラスメソッド（User.digest などの形で呼び出す）
  # ---------------------------------------------------------

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end