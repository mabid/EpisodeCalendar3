class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.integer :position
      t.boolean :important

      t.timestamps
    end
  end
end
