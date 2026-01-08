class AddMissingFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # すでに存在するかもしれないので、チェックを入れながら不足分だけ追加します
    add_column :users, :username, :string unless column_exists?(:users, :username)
    add_column :users, :is_admin, :boolean, default: false unless column_exists?(:users, :is_admin)
    add_column :users, :hourly_wage, :integer unless column_exists?(:users, :hourly_wage)
    add_column :users, :transportation_fee, :integer unless column_exists?(:users, :transportation_fee)
    add_column :users, :remember_digest, :string unless column_exists?(:users, :remember_digest)
  end
end