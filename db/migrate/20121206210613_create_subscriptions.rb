class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :plan_id
      t.string :profile_id
      t.string :status
      t.string :info

      t.timestamps
    end
  end
end
