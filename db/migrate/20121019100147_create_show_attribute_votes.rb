class CreateShowAttributeVotes < ActiveRecord::Migration
  def self.up
    create_table :show_attribute_votes do |t|
      t.integer :show_id
      t.integer :user_id
      t.string :show_attribute
      t.string :attribute_value
      t.timestamps
    end
  end

  def self.down
    drop_table :show_attribute_votes
  end
end
