class User < ApplicationRecord
  # パスワードを暗号化して扱うための魔法
  has_secure_password
  
  # === ここが重要！入力チェックのルール ===
  
  # 名前は必須、かつ50文字以内
  validates :name, presence: true, length: { maximum: 50 }
  
  # メールは必須、かつ255文字以内、かつ重複不可
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  
  # 時給は必須、かつ数値のみ
  validates :hourly_wage, presence: true, numericality: { only_integer: true }
  
  # パスワードは必須、かつ6文字以上（新規登録時のみチェック）
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end