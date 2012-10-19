class CreateMailBalancer < ActiveRecord::Migration
  def self.up
    create_table :mail_balancers do |t|
      t.integer :usage_count
      t.string :username
      t.date :date

      t.timestamps
    end
  end
  
  def self.down
    drop_table :mail_balancers
  end
end
