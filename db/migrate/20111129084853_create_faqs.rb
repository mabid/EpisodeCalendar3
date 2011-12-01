class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.integer :position, :default => 0
      t.boolean :important, :default => false

      t.timestamps
    end
  end
end
