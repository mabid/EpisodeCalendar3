class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.integer :show_id
      t.timestamps
    end
    add_index :banners, [:show_id]
  end
  
  def self.down
    drop_table :banners
  end
end