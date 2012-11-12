class AddIndexToFollowing < ActiveRecord::Migration
  def change
  	add_index :followings, :show_id
  	add_index :followings, [:user_id, :show_id]
  end
end
