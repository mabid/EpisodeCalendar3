# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Top 100 most popular shows from the production server (2012-06-15)
api_show_ids = [80379, 75760, 79349, 121361, 153021, 73255, 82066, 95011, 82283, 81189, 83610, 94571, 80348, 80349, 95491, 248682, 73762, 75978, 73244, 78901, 72227, 80547, 82459, 248835, 75897, 74845, 176941, 75682, 248646, 79488, 108611, 80337, 164091, 84947, 129261, 73800, 247897, 73871, 71663, 146711, 247808, 248742, 205281, 80270, 83462, 250487, 79334, 124051, 248837, 74543, 83602, 73739, 84912, 248736, 164301, 73141, 84676, 75710, 248741, 248935, 94991, 82696, 210841, 72108, 75805, 78804, 164541, 79335, 82339, 76354, 79501, 83123, 163531, 248884, 74608, 82716, 95451, 72546, 248735, 104281, 83237, 134241, 167571, 80542, 72218, 161511, 164021, 248880, 72158, 79216, 75340, 92411, 158661, 95441, 248868, 210171, 79168, 73388, 79773, 110381]
api_show_ids.each do |api_show_id|
	UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => api_show_id, :update_type => "show")
	UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => api_show_id, :update_type => "all_episodes")
	UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => api_show_id, :update_type => "banner")
end

puts "Start of plans creation"
Plan.delete_all
Plan.create!(:name => "free", :price => 0.0, :duration => "unlimited")
Plan.create!(:name => "1-Month", :price => 20.0, :duration => "1")
Plan.create!(:name => "3-Month", :price => 15.0, :duration => "3")
Plan.create!(:name => "6-Month", :price => 12.0, :duration => "6")
Plan.create!(:name => "12-Month", :price => 9.0, :duration => "12")
puts "Finishing plans creation"

puts "Queued shows for import. Run these commands to complete the import:"
puts "1. rake db:update_shows"
puts "2. rake db:get_show_episodes"
puts "3. rake db:get_banners"