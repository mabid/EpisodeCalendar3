class CreateDevise < ActiveRecord::Migration
  def self.up
    rename_column(:users, :login, :name)
    rename_column(:users, :crypted_password, :encrypted_password)
    rename_column(:users, :salt, :password_salt)

    rename_column(:users, :activation_code, :confirmation_token)
    rename_column(:users, :activated_at, :confirmed_at)
    rename_column(:users, :reset_code, :reset_password_token)
    rename_column(:users, :remember_token_expires_at, :remember_created_at)
    
    add_column(:users, :authentication_token, :string, {})
    add_column(:users, :confirmation_sent_at, :datetime, {})
    
    add_column(:users, :sign_in_count, :integer, { :default => 0 })
    add_column(:users, :current_sign_in_at, :datetime, {})
    add_column(:users, :last_sign_in_at, :datetime, {})
    add_column(:users, :current_sign_in_ip, :string, {})
    add_column(:users, :last_sign_in_ip, :string, {})
    
    add_index :users, :name
    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    rename_column(:users, :name, :login)
    rename_column(:users, :encrypted_password, :crypted_password)
    rename_column(:users, :password_salt, :salt)

    rename_column(:users, :confirmation_token, :activation_code)
    rename_column(:users, :confirmed_at, :activated_at)
    rename_column(:users, :reset_password_token, :reset_code)
    rename_column(:users, :remember_created_at, :remember_token_expires_at)

    remove_column(:users, :authentication_token)
    remove_column(:users, :confirmation_sent_at)
    
    remove_column(:users, :sign_in_count)
    remove_column(:users, :current_sign_in_at)
    remove_column(:users, :last_sign_in_at)
    remove_column(:users, :current_sign_in_ip)
    remove_column(:users, :last_sign_in_ip)
  end
end