namespace :db do
  desc "Erase and fill database"
  task :count_seen_episodes => :environment do
    
    puts "Counting..."
    total_size = SeenEpisode.count
    last_record = Statistic.seen_episodes.order("id desc").first

    if last_record.blank?
      puts "Today's total size: #{total_size}"
      Statistic.create(key: "seen_episodes", value: total_size, additional_data: 0)
    else
      increase = total_size - last_record.value
      puts "Today's total size: #{total_size}, +#{increase}"
      Statistic.create(key: "seen_episodes", value: total_size, additional_data: increase)
    end
    
  end
end