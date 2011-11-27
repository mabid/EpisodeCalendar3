class MailBalancerGenerator < Rails::Generators::Base
  def create_initializer_file

content = 
<<-eos
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
eos

    create_file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M")}_create_mail_balancer.rb", content
  end
end