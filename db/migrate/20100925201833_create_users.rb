class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     	:string
      t.column :email,                     	:string
      t.column :crypted_password,          	:string, 		:limit => 40
      t.column :salt,                      	:string, 		:limit => 40
      t.column :created_at,                	:datetime
      t.column :updated_at,                	:datetime
      t.column :remember_token,            	:string
      t.column :remember_token_expires_at, 	:datetime
      t.column :reset_code,                 :string
      t.column :activation_code, 						:string, 		:limit => 40
      t.column :activated_at, 							:datetime
      t.column :show_format, 								:integer, 	:default => 2
      t.column :episode_format, 						:integer, 	:default => 2
      t.column :time_zone,                  :string,    :default => "UTC"
      t.column :sun_to_sat,                 :boolean,   :default => false
      t.column :daily_notification,         :boolean,   :default => false
      t.column :weekly_notification,        :boolean,   :default => false
      t.column :only_premiere_notification, :boolean,   :default => false
      t.column :admin,                      :boolean,   :default => false
      t.column :followings_count,           :integer,   :default => 0
      t.column :hide_overview_in_rss,       :boolean,   :default => false
      t.column :hide_profile,               :boolean,   :default => false
    end
  end

  def self.down
    drop_table "users"
  end
end