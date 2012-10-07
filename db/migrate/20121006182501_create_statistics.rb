class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :key
      t.integer :value
      t.string :additional_data

      t.timestamps
    end
  end
end
