# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# # db/seeds.rb
# User.create!(
#   username: "admin01", # user_id ではなく username
#   password: "password123",
#   password_confirmation: "password123",
#   hourly_wage: 1500,
#   transportation_fee: 500,
#   is_admin: true
# )
# #
# # db/seeds.rb

# # 管理ユーザーを1人作成する
# User.find_or_create_by!(username: "admin") do |user|
#   user.password = "password123"
#   user.password_confirmation = "password123"
#   # もし管理者フラグなどのカラムがあれば、ここで設定
#   # user.admin = true 
# end

# puts "Seed: Admin user has been created/verified."