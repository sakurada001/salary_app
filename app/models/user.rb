class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password

  # 永続セッションのためにユーザーをDBに保存する [cite: 85]
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致するか確認する
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する [cite: 86]
  def forget
    update_attribute(:remember_digest, nil)
  end

  # クラスメソッド（ヘルパーから呼び出す用）
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end