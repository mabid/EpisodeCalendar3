class AddWatchLaterToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :watch_later, :boolean, :default => false
  end
end
