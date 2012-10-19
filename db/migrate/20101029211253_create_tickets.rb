class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :from
      t.string :email
      t.string :category
      t.string :subject
      t.text :message
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tickets
  end
end
