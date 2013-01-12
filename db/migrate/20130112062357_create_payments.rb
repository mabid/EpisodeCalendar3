class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :plan_id
      t.float :amount
      t.boolean :success

      t.timestamps
    end
  end
end
