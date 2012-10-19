require 'active_record'

namespace :mail_balancer do 
  desc "Add database tables for mail balancer"
  task :setup => :environment do
    CreateMailBalancerTable.up
    puts "Mail Balancer tables created successfully!"
  end
end

class CreateMailBalancerTable < ActiveRecord::Migration
  def self.up
    create_table :mail_balancers do |t|
      t.integer :usage_count
      t.string :username
      t.date :date

      t.timestamps
    end
  end
end